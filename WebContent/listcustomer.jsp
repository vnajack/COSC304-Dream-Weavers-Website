<!DOCTYPE html>
<html>
<head>
<title>All Customers</title>
</head>
<body>
	<%@ include file="header.jsp"%>
	<%@ include file="auth.jsp"%>
	<%@ page import="java.text.NumberFormat"%>
	<%@ include file="jdbc.jsp"%>

	<%
String username=(String)session.getAttribute("authenticatedUser");

if(username!=null){
	getConnection();
	
	String sql =  "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid "
			+ "FROM customer ";

	try(Statement stm = con.createStatement();){
		
		ResultSet rst = stm.executeQuery(sql);
		out.println("<table style='border-collapse:collapse; float:center'>"
				+ "<tr style='border-bottom: 1px solid #555;'>" 	
				+ "<th>Customer Id</th>"			
				+ "<th>First Name</th>"		
				+ "<th>Last Name <br>"
				+ "<th >Email</th>"
				+ "<th >Phone</th>"
				+ "<th >Address</th>"
				+ "<th >City</th>"
				+ "<th >State</th>"
				+ "<th >Postal Code</th>"
				+ "<th >Country</th>"
				+ "<th >User Id</th>"
				+ "</tr>");
		while(rst.next()){
			out.print("<tr style='border-bottom: 1px solid #555;'>" 
					+ "<td align='center'>"+rst.getInt(1)+"</td>"	
					+ "<td align='center'>"+rst.getString(2)+"</td>"	
					+ "<td align='center'>"+rst.getString(3)+"</td>"	
					+ "<td align='center'>"+rst.getString(4)+"</td>"	
					+ "<td align='center'>"+rst.getString(5)+"</td>"	
					+ "<td align='center'>"+rst.getString(6)+"</td>"
					+ "<td align='center'>"+rst.getString(7)+"</td>"
					+ "<td align='center'>"+rst.getString(8)+"</td>"
					+ "<td align='center'>"+rst.getString(9)+"</td>"
					+ "<td align='center'>"+rst.getString(10)+"</td>"
					+ "<td align='center'>"+rst.getString(11)+"</td></tr>"
					);
					
	}
	}catch(SQLException e){
		out.print("<p>Error. " + e + "</p>");
	}
}

%>
</body>
</html>