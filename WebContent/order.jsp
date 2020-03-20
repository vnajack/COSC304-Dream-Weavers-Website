<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html>
	<head>
		<title>Dream Vine Order Processing</title>
	</head>
	<body>
<% 
	// Get customer id
	@SuppressWarnings({"unchecked"})
	HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
	
	try { // Load driver class
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	} catch (java.lang.ClassNotFoundException e) {
		out.println("ClassNotFoundException: " + e);
	}
	
	// Connection Info
		String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_vjack;";
		String uid = "vjack";
		String pw = "12304986";
	
	// Determine if valid customer id was entered
	
	boolean invalidCustomerId = false;
	boolean emptyShoppingCart = false;
	Integer custId=(Integer)session.getAttribute("authenticatedId");

	try(Connection con = DriverManager.getConnection(url, uid, pw); 
		Statement stmt = con.createStatement();){
	String sql="SELECT * FROM customer WHERE customerId = ?";	//query statement
	PreparedStatement pstm = con.prepareStatement(sql);	//create preparedstatement
	pstm.setInt(1, custId);	//fill in ?
	ResultSet rst = pstm.executeQuery(); // get resultset
	if (!rst.next()){
		throw new Exception();
	}
	}catch (Exception e){
		invalidCustomerId = true;
	}

	// Determine if there are products in the shopping cart
	if(productList==null || productList.isEmpty()){
		emptyShoppingCart = true;
	}
	
	// If either are not true, display an error message
	if(invalidCustomerId && !emptyShoppingCart){
		out.print("<h3 style='text-align:center'>Unable to process. Invalid customer ID</h3>"
				+ "<div class='wrapper' style='text-align:center;'><a href='checkout.jsp'><button>Try Again</button></a></div>");
	}else if(emptyShoppingCart && !invalidCustomerId){
		out.print("<h3 style='text-align:center'>Unable to process. Shopping cart is empty. </h3>"
				+ "<div class='wrapper' style='text-align:center;'><a href='checkout.jsp'><button>Try Again</button></a></div>");
	}else if(emptyShoppingCart && invalidCustomerId){
		out.print("<h3 style='text-align:center'>Unable to process. Invalid customer ID and shopping cart is empty. </h3>"
				+ "<div class='wrapper' style='text-align:center'><a href='checkout.jsp'><button>Try Again</button></a></div>");
	}else try(Connection con = DriverManager.getConnection(url, uid, pw);
			Statement stmt = con.createStatement();){ // Make connection
		// Save order information to database
		
		Date date = new Date(System.currentTimeMillis());
		SimpleDateFormat dateFormatter = new SimpleDateFormat("YYYY-MM-dd HH:mm:ss");
		
		String sql1="INSERT INTO ordersummary (customerId, orderDate) "
				+"VALUES ("+custId+", '"+ dateFormatter.format(date) + "') ";
		// Use retrieval of auto-generated keys.
		PreparedStatement pstmt = con.prepareStatement(sql1, Statement.RETURN_GENERATED_KEYS);	
		pstmt.execute();
		ResultSet keys = pstmt.getGeneratedKeys();
		keys.next();
		int orderId = keys.getInt(1);
		NumberFormat currFormat = NumberFormat.getCurrencyInstance();
		

		out.print("<h1>Your Order Summary</h1>");
		
		out.print("<table style='border-collapse:collapse; float:center'>"
				+ "<tr style='border-bottom: 1px solid #243743;'>" //outer header row (1st row)
				+ "<th>Product Id</th>"		
				+ "<th>Product Name</th>"		
				+ "<th>Quantity</th>"			
				+ "<th>Price</th>"		
				+ "<th>Subtotal</th>"
				+ "</tr>");	//end of header row (1st row)

		Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
		double orderTotal=0;
		while (iterator.hasNext()) {	
			// Insert each item into OrderProduct table using OrderId from previous INSERT
			Map.Entry<String, ArrayList<Object>> entry = iterator.next();
			ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
			
			String productId = (String) product.get(0);
		    String price = (String) product.get(2);
			double pr = Double.parseDouble(price);
			int qty = ( (Integer)product.get(3)).intValue();
			
			// Calculate total amount
			orderTotal+=pr*qty;
			
			String sql2="INSERT INTO orderproduct (orderId,productId,quantity,price) VALUES ("
			+orderId+", "
			+productId+", "
			+qty+", "
			+pr +")";
			stmt.executeUpdate(sql2);
			
			String sql3 = "SELECT productName FROM product WHERE productId = " + productId;
			ResultSet rst3 = stmt.executeQuery(sql3);
			while(rst3.next()){
			out.print("<tr style='border-bottom: 1px solid #243743;'>"
					+"<td align='center'> " + productId +" </td>"	//product id
					+"<td align='center'>" + rst3.getString("productName") + "</td>"	//product name
					+"<td align='center'> " + qty +" </td>"	//quantity
					+"<td align='right'> " + currFormat.format(pr) +" </td>" //price
					+"<td align='right'> " + currFormat.format(qty*pr) +" </td>" //subtotal
				+"</tr>");
			}
		}
		
		// Update total amount for order record
		sql1="UPDATE ordersummary SET totalAmount="+orderTotal+" WHERE orderId="+orderId;
		stmt.executeUpdate(sql1);
		
		// Clear cart if order placed successfully
		session.setAttribute("productList", null);
		
		// Print out order summary
		
		out.print("<tr style='background-color:#243743'><td colspan='5' align='right'><b>Order Total: </b>" + currFormat.format(orderTotal) + "</td></tr></table>");
		
		out.print("<p> Your order reference number is " + orderId + "</p>");
		
		String getCustName = "SELECT firstName, lastName FROM customer WHERE customerId = " + custId;
		ResultSet rstCustName = stmt.executeQuery(getCustName);		
		
		while(rstCustName.next()){
		out.print("<p> Shipping to "+ rstCustName.getString("firstName") + " " + rstCustName.getString("lastName") + " (customer Id: " + custId + ")</p>");
		}
		
		out.print("<h3>Order Completed. Your order will arrive within 2 hours via our sustainable and efficient Dream Bombers*.</h3>"
				+"<p style='font-size:10px'>*Dream Bombers are the Dream Weavers' patented solar-powered aerial and marine drones, which are located in each warehouse around the world to deliver quality dreams to any person anywhere within 2 hours.</p>");
		
	} catch (SQLException e){
		System.out.println(e);
	}
%>
</BODY>
</HTML>

