<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>
<%
String createdUser = null;
session = request.getSession(true);

try {
	createdUser = validateCustomer(out,request,session);
}
	catch(IOException e)
{ System.err.println(e); }

if(createdUser == null) //that username has not been used before
	response.sendRedirect("createCustomerComplete.jsp"); // Successful creation of user
else
	response.sendRedirect("createCustomer.jsp"); // Failed to create user - redirect back to create customer page with a message
%>


<%!
	String validateCustomer(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException {
	
	
	String username = request.getParameter("username");
	String password = request.getParameter("password");
	String userFirstName = request.getParameter("firstName");
	String userLastName = request.getParameter("lastName");
	String useremail = request.getParameter("email");
	String userphoneNumber = request.getParameter("phonenum");
	String useraddress = request.getParameter("address");
	String usercity = request.getParameter("city");
	String userstate = request.getParameter("state");
	String userpostalCode = request.getParameter("postalCode");
	String usercountry = request.getParameter("country");
	String retStr = null;
	
	String[] requiredFields = new String[]{username,password, userFirstName, userLastName, useremail};
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
				session.setAttribute("createUserMessage", error);
				retStr = "not valid";
				return retStr;
			}
		}

	try{
		getConnection();

		// Check if userId matches some customer account. If so, set retStr to be the username.
		String sql = "SELECT userid, password FROM customer WHERE userid = ?";
		PreparedStatement getId = con.prepareStatement(sql);
		getId.setString(1, username);
		ResultSet userId = getId.executeQuery();
		while (userId.next()){ //username is already taken
		retStr = username;
		}

		if (retStr == null){ //i.e that username is not already in the database
	//	System.out.println("Creating user");


	//	System.out.println("Obtained user information");
	//	System.out.println(" " + userFirstName + " " + userLastName + " " + useremail + " " + userphoneNumber + " " + useraddress + " " + usercity + " " + userstate + " " + userpostalCode + " " + usercountry + " " + " " + username + " " + password);

		//String insertCustomer = "INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country) VALUES (firstName, lastName, email, phoneNumber, address, city, state, postalCode, country)";
		//String insertCustomer = "INSERT INTO customer VALUES (NULL, firstName, lastName, email, phoneNumber, address, city, state, postalCode, country)";
		String insertCustomer = "INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		PreparedStatement pstmInsert = con.prepareStatement(insertCustomer);
		pstmInsert.setString(1, userFirstName);
		pstmInsert.setString(2, userLastName);
		pstmInsert.setString(3, useremail);
		pstmInsert.setString(4, userphoneNumber);
		pstmInsert.setString(5, useraddress);
		pstmInsert.setString(6, usercity);
		pstmInsert.setString(7, userstate);
		pstmInsert.setString(8, userpostalCode);
		pstmInsert.setString(9, usercountry);
		pstmInsert.setString(10, username);
		pstmInsert.setString(11, password);
		pstmInsert.executeUpdate();
	//	System.out.println("User Created");
		}


	}
	catch (SQLException ex) {
	out.print("<p>Error. "+ex+"</p>");
	}
	finally
	{
	closeConnection();
	}

	if(retStr != null) //i.e username not in database
	{ session.setAttribute("createUserMessage", "That username is already being used. Please enter another: ");
	}
	else {
	session.removeAttribute("createUserMessage");
	session.setAttribute("createdUser",username);
	}


	return retStr;
}
%>