<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>
<%
	Integer authenticatedId = null;
	session = request.getSession(true);

	try
	{
		authenticatedId = validateId(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(authenticatedId != null)
		response.sendRedirect("customerpayment.jsp");		// Successful login
	else
		response.sendRedirect("checkout.jsp");		// Failed login - redirect back to login page with a message 
%>


<%!
	Integer validateId(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String id = request.getParameter("customerId");
		String password = request.getParameter("password");
		String retStr = null;
		Integer retId = null;

		if(id == null || password == null)
				return null;
		if((id.length() == 0) || (password.length() == 0))
				return null;

		try 
		{
			getConnection();
			
			// TODO: Check if userId and password match some customer account. If so, set retStr to be the username.
			String sql = "SELECT userid, password FROM customer WHERE customerId = ? AND password = ?";
			PreparedStatement getIdAndPassword = con.prepareStatement(sql);
			getIdAndPassword.setString(1, id);
			getIdAndPassword.setString(2, password);
			ResultSet userIdandPassword = getIdAndPassword.executeQuery();
			while (userIdandPassword.next()){
					retId = Integer.parseInt(id);
			}
						
		} 
		catch (SQLException ex) {
			out.println(ex);
		}
		finally
		{
			closeConnection();
		}	
		
		if(retId != null)
		{	session.removeAttribute("IDMessage");
			session.setAttribute("authenticatedId",retId);
		}
		else
			session.setAttribute("IDMessage","Could not connect to the system using that id/password.");

		return retId;
	}
%>

