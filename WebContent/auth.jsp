<%
	boolean authenticated = session.getAttribute("authenticatedUser") == null ? false : true;

	if (!authenticated)
	{
		String loginMessage = "<p>You have not been authorized to access the URL "+request.getRequestURL().toString() + "</p>";
        session.setAttribute("loginMessage",loginMessage);        
		response.sendRedirect("login.jsp");
	}
%>
