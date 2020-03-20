<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>
<%@ include file="header.jsp" %>
<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
String username=(String)session.getAttribute("authenticatedUser");

if(username!=null){
	getConnection();
	
	String sql = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid "
			+ "FROM customer "
			+ "WHERE userid = ?";

	try(PreparedStatement pstm = con.prepareStatement(sql);){
		pstm.setString(1, username);
		ResultSet rst = pstm.executeQuery();
		while(rst.next())
			out.print("<h1>" + rst.getString("firstName") + "'s Customer Profile</h1>"
					+ "<p style='text-align:center'>Please take note of your customer Id. This is required when purchasing products.</p>"
					+ "<table style='text-align:left'>"
					+ "<tr><th>Customer Id</th><td>"+ rst.getInt(1)+"</td></tr>"
					+ "<tr><th>User Id</th><td>"+ rst.getString(11)+"</td></tr>"
					+ "<tr><th>First Name</th><td>"+ rst.getString(2) +"</td></tr>"
					+ "<tr><th>Last Name </th><td>"+ rst.getString(3) + "</td></tr>"
					+ "<tr><th>Email</th><td>"+ rst.getString(4)+"</td></tr>"
					+ "<tr><th>Phone</th><td>"+ rst.getString(5)+"</td></tr>"
					+ "<tr><th>Address</th><td>"+ rst.getString(6)+"</td></tr>"
					+ "<tr><th>City</th><td>"+ rst.getString(7)+"</td></tr>"
					+ "<tr><th>State</th><td>"+ rst.getString(8) +"</td></tr>"
					+ "<tr><th>Postal Code</th><td>"+ rst.getString(9)+"</td></tr>"
					+ "<tr><th>Country</th><td>"+ rst.getString(10)+"</td></tr>"
					+ "</table>"
					+ "<button onclick=\"window.location.href=\'editcustomer.jsp\'\">Edit</button>");

	}catch(SQLException e){
		out.print("<p>Error. " + e + "</p>");
	}
}

%>
</body>
</html>

