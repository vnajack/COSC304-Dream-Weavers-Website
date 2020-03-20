<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>
<%
	String createdUser = null;
	session = request.getSession(true);
	
	
	String username = request.getParameter("username");
	String password = request.getParameter("password");
	String firstName = request.getParameter("firstName");
	String lastName = request.getParameter("lastName");
	String email = request.getParameter("email");
	String phonenum = request.getParameter("phonenum");
	String address = request.getParameter("address");
	String city = request.getParameter("city");
	String state = request.getParameter("state");
	String postalCode = request.getParameter("postalCode");
	String country = request.getParameter("country");
	
	String[] requiredFields = new String[]{username,password, firstName, lastName, email};
		int index = -1;
		String field = "";
		String error = "";
		for (String s: requiredFields){
			index++;
			if (s == null || s.length() == 0){
				switch (index) {
					case 0:
						field = "User id is required.";
						break;
					case 1:
						field = "Password is required.";
						break;
					case 2:
						field = "First Name is required.";
						break;
					case 3:
						field = "Last Name is required.";
						break;
					case 4:
						field = "Email is required.";
						break;
					default:
						field = "Please fill in the required fields.";
				}
				error += field + " Please try again.";
				
				
			}
		}

	try{
		getConnection();

		// Check if userId matches some customer account. If so, set retStr to be the username.
		

		
		String insertCustomer = "UPDATE customer SET firstName=?,lastName=?,email=?,phonenum=?,address=?,city=?,state=?,postalCode=?,country=?,password=? WHERE userid=?";
		PreparedStatement pstm = con.prepareStatement(insertCustomer);
		pstm.setString(1, firstName);
		pstm.setString(2, lastName);
		pstm.setString(3, email);
		pstm.setString(4, phonenum);
		pstm.setString(5, address);
		pstm.setString(6, city);
		pstm.setString(7, state);
		pstm.setString(8, postalCode);
		pstm.setString(9, country);
		pstm.setString(10, password);
		pstm.setString(11, username);
		
		pstm.executeUpdate();
		
		
		response.sendRedirect("customer.jsp");

	}
	catch (SQLException ex) {
	out.print("<p>Error. "+ex+"</p>");
	}
	finally
	{
	closeConnection();
	}

%>