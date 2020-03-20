<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>

<html>
<head>
<title>Product Information</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%
// Get product name to search for
// TODO: Retrieve and display info for the product
try{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}catch (java.lang.ClassNotFoundException e){
	out.println("ClassNotFoundException: " +e);
}

// Make the connection
String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_vjack;";
String uid = "vjack";
String pw = "12304986";

try(Connection con = DriverManager.getConnection(url, uid, pw);){

	String prodId = request.getParameter("id");
	int productId = Integer.parseInt(prodId);
	
	String sql =  "SELECT productId, productName, productPrice, productImageURL, productDesc, categoryName "
			+ "FROM product "
			+ "INNER JOIN category "
			+ "ON product.categoryId = category.categoryId "
			+ "WHERE productId = ?";
	PreparedStatement pstm = con.prepareStatement(sql);
	pstm.setInt(1, productId);
	ResultSet rst = pstm.executeQuery();
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();
	

	while (rst.next()){
		String addCartLink = "addcart.jsp?id=" + productId + "&name=" + rst.getString("productName") + "&price=" + rst.getDouble("productPrice");
	
		out.print( // TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
				"<img style='height:200px' src='"+ rst.getString("productImageURL") +"'>"
				+ "<br>"
				
				+ "<table margin-left='auto' margin-right='auto'>"
					+ "<tr text-align='left'>"
						+ "<th font-size='16px' colspan=2>" + rst.getString("productName") + "</th>"
					+"</tr>" 
					+ "<tr>"
						+"<td>Category: </td>"
						+"<td>" + rst.getString("categoryName") + "</td></tr>"
					+ "<tr>"
						+"<td>Price: </td>"
						+"<td>" + currFormat.format(rst.getDouble("productPrice")) + "</td>"
					+"</tr>" 
					+ "<tr>"
						+"<td>Description: </td>"
						+"<td>" + rst.getString("productDesc") + "</td>"
					+"</tr>"
				+ "</table>"
				
				+ "<a href='" + addCartLink + "'><button>Add to Cart</button></a>&nbsp"
				+ "<a href='listprod.jsp'><button>Continue Shopping</button></a>"
				
				+ "<br><br>"
				+ "<table width=30% margin-left='auto' margin-right='auto'>"
				+ "<tr>"
					+"<th>Reviews</th>"
					+ "</tr>");
	}

	String sql2 =  "SELECT reviewRating, reviewDate, reviewComment, userid "
			+ "FROM review "
			+ "INNER JOIN customer "
			+ "ON customer.customerId = review.customerId "
			+ "WHERE productId = ?";
	PreparedStatement pstm2 = con.prepareStatement(sql2);
	pstm2.setInt(1, productId);
	ResultSet rst2 = pstm2.executeQuery();
	
	while (rst2.next()){

	out.print( // TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.

					
					"<tr style='border-bottom: 1px solid #555555;'><td>"
						+"<b>" + rst2.getString("userid") + "</b><br/>"	//customer's username
						+"<span style='color:#FFD700'>" + rst2.getInt("reviewRating") + " out of 5</span><br/>"	//customer's rating out of 5
						+"<span style='color:#808080'>" + rst2.getDate("reviewDate") + "</span><br/>"		//date when customer left rating
						+ rst2.getString("reviewComment")
					+ "</td></tr>");
		}
	out.print("</table>");

	}catch(SQLException e){
		out.print("<p>Error.</p>");
	}
%>
</body>
</html>

