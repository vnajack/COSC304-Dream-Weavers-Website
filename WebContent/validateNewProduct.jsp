
<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%  String createdProduct = null;
	session = request.getSession(true);

	try
	{
		createdProduct = validateNewProduct(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(createdProduct == null) //that username has not been used before
		response.sendRedirect("productsadmin.jsp");		// Successful creation of user
	else
		response.sendRedirect("addProduct.jsp");		// Failed to create user - redirect back to create customer page with a message 
%>


<%!
	String validateNewProduct(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String productName = request.getParameter("productName");
		String productPrice = request.getParameter("productPrice");
		String productDesc = request.getParameter("productDesc");
		String categoryName = request.getParameter("categoryName");
		String retStr = null;

		if(productName == null||productName.length()==0){
			retStr = "not valid";
			return retStr;
		}
		if(productPrice==null||categoryName==null||productPrice.length()==0){
			retStr = "not valid";	
			return retStr;
		}
		try 
		{
			getConnection();
			 
			// TODO: Check if userId and password match some customer account. If so, set retStr to be the username.
			String sql = "SELECT productId FROM product WHERE productName = ?";
			PreparedStatement getId = con.prepareStatement(sql);
			getId.setString(1, productName);
			ResultSet productId = getId.executeQuery();
			while (productId.next()){ //product name is already taken
				retStr = productName;
				}
			
			if (retStr == null){ 
				
				String getCategoryId="SELECT categoryId FROM category WHERE categoryName='"+categoryName+"'";
				Statement stm=con.createStatement();
				
				ResultSet categoryId =stm.executeQuery(getCategoryId);
				categoryId.next();
				int ctgr=categoryId.getInt(1);
				
				Double prc=Double.parseDouble(productPrice);
				String insertProduct = "INSERT INTO product (productName, productPrice, productDesc, categoryId) VALUES (?, ?, ?, ?)";
				
				PreparedStatement pstmInsert = con.prepareStatement(insertProduct);
				
				
				
				pstmInsert.setString(1, productName);
				pstmInsert.setDouble(2, prc);
				pstmInsert.setString(3, productDesc);
				pstmInsert.setInt(4, ctgr);
				
				pstmInsert.executeUpdate();
			}
			
						
		} 
		catch (SQLException ex) {
			out.println(ex);
		}
		finally
		{   
			closeConnection();
		}	
		
		if(retStr != null) //i.e username not in database
		{	session.setAttribute("createMessage", "<p>That product name already exists.</p>");
		}
		else {
			session.removeAttribute("createMessage");
			session.setAttribute("createdProduct",productName);
		}
			

		return retStr;
	}
%>