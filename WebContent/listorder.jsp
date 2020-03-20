<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html>
<head>
<title>Dream Vine Order List</title>
</head>
<body>
<h1>Dream Vine Order List</h1>
<p style="text-size:10px"><i>Special thanks to Arnold Anderson for his relentless testing of our Dream Vine</i></p>

<%
//Note: Forces loading of SQL Server driver
try{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
} catch (java.lang.ClassNotFoundException e) {
	out.println("ClassNotFoundException: " +e);
}

String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_vjack;";
String uid = "vjack";
String pw = "12304986";

try(Connection con = DriverManager.getConnection(url, uid, pw);){
	
	String query1 = "SELECT ordersummary.orderId, ordersummary.orderDate, ordersummary.customerId, customer.firstName, customer.lastName, ordersummary.totalAmount "
			+ "FROM ordersummary, customer "
			+ "WHERE ordersummary.customerId = customer.customerId ";
	
	String query2 = "SELECT orderId, productId, quantity, price FROM orderproduct WHERE orderId = ?";
	
	PreparedStatement pstmt = con.prepareStatement(query1);
	PreparedStatement pstmt2 = con.prepareStatement(query2);
	
	ResultSet rst = pstmt.executeQuery();
	ResultSet rst2 = null;
	
	//Outer Table
	out.print("<table style='border-collapse:collapse; float:center'>"
				+ "<tr style='border-bottom: 1px solid #555;'>" //outer header row (1st row)
				+ "<th>Order Id</th>"		
				+ "<th>Order Date</th>"		
				+ "<th>Customer Id</th>"			
				+ "<th>Customer Name</th>"		
				+ "<th>Order Summary <br>"
				+ "<table style='width:220px;float:center'>" 
						+ "<tr>" //inner table header row
						+ "<th width='100px'>Product Id</th>"
						+ "<th width='40px'>Quantity</th>"
						+ "<th width='80px'>Price</th></tr></table>" //end of inner table header row
				+"</th>"
				+ "<th >Total Amount</th>"
				+ "</tr>");	//end of header row (1st row)
	

	
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();
	while(rst.next()){
		out.print("<tr style='border-bottom: 1px solid #555'>" //outer table content begins (2nd row)
				+ "<td align='center'>"+rst.getInt(1)+"</td>"	//Order Id
				+ "<td align='center'>"+rst.getDate(2)+" "+rst.getTime(2)+"</td>"	//Order Date
				+ "<td align='center'>"+rst.getInt(3)+"</td>"	//Customer Id
				+ "<td align='left'>"+rst.getString(4)+" "+rst.getString(5)+"</td>"	//Customer Name
				+ "<td align='center'>");
		
		pstmt2.setInt(1, rst.getInt(1));
		rst2 = pstmt2.executeQuery();		
		//Inner Table header
		out.print("<table style='float:center'>"); //inner table

		while(rst2.next()){
			out.println("<tr>"
					+ "<td align='center' width='100px'>"+rst2.getInt(2)+"</td>"
					+ "<td align='center' width='40px'>"+rst2.getInt(3)+"</td>"
					+ "<td align='center' width='80px'>"+currFormat.format(rst2.getDouble(4))+"</td>"
					+ "</tr>");
			
		} //End of Inner Table
		out.println("</table>"); //End of inner table
		out.print("<td>"+currFormat.format(rst.getDouble(6))+"</td></tr>"); //Total Amount
		out.println("</tr>");
	} //while(rst.next())
	out.println("</table>");
	
}catch(SQLException e){
	out.print("<p>Error. "+e+"</p>");
}

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);  // Prints $5.00

// Make connection

// Write query to retrieve all order summary records

// For each order in the ResultSet

	// Print out the order summary information
	// Write a query to retrieve the products in the order
	//   - Use a PreparedStatement as will repeat this query many times
	// For each product in the order
		// Write out product information 

// Close connection
%>

</body>
</html>

