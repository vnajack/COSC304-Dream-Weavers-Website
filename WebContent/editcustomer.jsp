<!DOCTYPE html>
<html>
<head>
<title>Edit Customer Page</title>
</head>
<body>
<%@ include file="header.jsp" %>
<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
	String username=(String)session.getAttribute("authenticatedUser");
	out.print("<form name=\"EditCustForm\" method=post action=\"updateCustomer.jsp?username="+username+
			"\" autocomplete=\"off\">");


if(username!=null){
	getConnection();
	
	String sql =  "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password "
			+ "FROM customer "
			+ "WHERE userid = ?";
	
	try(PreparedStatement pstm = con.prepareStatement(sql);){
		pstm.setString(1, username);
		ResultSet rst = pstm.executeQuery();
		while(rst.next())
			out.print("<h1>Edit " + rst.getString("firstName") + "'s Customer Profile</h1>"
					+ "<table>"
					+ "<tr>"
						+"<th><label for='custId'>Customer Id: </label></th>"
						+"<td><input disabled type='text' name='custId' size=40 value='"+ rst.getInt("customerId") +"'>"
					+ "</tr>"
					+ "<tr>"
						+ "<th><label for='username'>User Id: </label></th>"
						+ "<td><input disabled type='text' name='userid' size=40 value='"+username+ "'></td>"
					+ "</tr>"
					+ "<tr>"
						+ "<th><label for='password'>Password: </label></th>"
						+ "<td><input required type='password' name='password' size=40 value='"+ rst.getString("password") +"' pattern='.{6,}'></td>"
					+ "</tr>"
					+ "<tr>"
						+ "<th><label for='firstName'>First Name: </label></th>"
						+ "<td><input required type='text' name='firstName' size=40 value='"+rst.getString("firstname")+ "' pattern='[a-zA-Z- ]+' title='Can only contain letters, hyphens, and spaces.'></td>"
					+ "</tr>"
					+ "<tr>"	
						+ "<th><label for='lastName'>Last Name: </label></th>"
						+ "<td><input required type='text' name='lastName' size=40 value='"+rst.getString("lastname")+ "'  pattern='[a-zA-Z- ]+' title='Can only contain letters, hyphens, and spaces.'></td>"
					+ "</tr>"
					+ "<tr>"
						+ "<th><label for='email'>Email: </label></th>"
						+ "<td><input required type='text' name='email' size=40 value='"+rst.getString("email")+ "' pattern='[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,}$' title='Must contain characters before and after \'@\' and at least two characters after \'.\''></td>"
					+ "</tr>"
					+ "<tr>"
						+ "<th><label for='phonenum'>Phone Number: </label></th>"
						+ "<td><input type='text' name='phonenum' size=40 value='"+rst.getString("phonenum")+ "' pattern='[0-9]{10}' title='Must be a 10-digit phone number in the format 123-456-7890' ></td>"
					+ "</tr>"
					+ "<tr>"
						+ "<th><label for='address'>Street Address: </label></th>"
						+ "<td><input type='text' name='address' size=40 value='"+ rst.getString("address") +"' pattern='[a-zA-Z0-9- ]+' title='Can only contain letters, numbers, hyphens, and spaces.'></td>"
					+ "</tr>"
					+ "<tr>"
						+ "<th><label for='city'>City: </label></th>"
						+ "<td><input type='text' name='city' size=40 value='"+rst.getString("city")+ "' pattern='[a-zA-Z- ]+' title='Can only contain letters, hyphens, and spaces'></td>"
					+ "</tr>"
					+ "<tr>"
						+ "<th><label for='city'>Province/State: </label></th>"
						+ "<td><input type='text' name='state' size=40 value='"+ rst.getString("state") +"' pattern='[a-zA-Z- ]+' title='Can only contain letters, hyphens, and spaces'></td>"
					+ "</tr>"
					+ "<tr>"
						+ "<th><label for='postalCode'>Postal Code: </label></th>"
						+ "<td><input type='text' name='postalCode' size=40 value='"+rst.getString("postalCode")+ "' pattern='[a-zA-Z0-9- ]{5,10}' title='Must be 5-10 characters long and can only contain letters, numbers, hyphens, and spaces'></td>"
					+ "</tr>"
					+ "<tr>"
						+ "<th><label for='country'>Country: </label></th>"
						+ "<td><input type='text' name='country' size=40 value='"+rst.getString("country")+ "'></td>"
					+ "</table>"
					+"<input type='submit' size=40 value=\"Update\">");
					
		

	}catch(SQLException e){
		out.print("<p>Error. " + e + "</p>");
	}
}
	out.print("</form>");
%>
</body>
</html>

