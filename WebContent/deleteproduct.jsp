<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp"%>
<%@ include file="header.jsp"%>
<%@ include file="auth.jsp"%>
<%
	String productId = request.getParameter("productId");

	try {
		getConnection();

	
		Statement stm=con.createStatement();
		
		String sql1="DELETE FROM orderproduct WHERE productId="+productId;
		String sql2 = "DELETE FROM product WHERE productId="+productId;
		
		stm.executeUpdate(sql1);
		stm.executeUpdate(sql2);

		response.sendRedirect("productsadmin.jsp");

	} catch (SQLException ex) {
		out.print("<p>Error. " + ex + "</p>");
	} 
%>