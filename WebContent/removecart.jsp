<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.ArrayList"%>
<%
	// Get the current list of products
	@SuppressWarnings({ "unchecked" })
	HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session
			.getAttribute("productList");

	if (productList != null && !productList.isEmpty()) { // If the list has been created.  Create a list.
		String id = request.getParameter("id");
		if (productList.containsKey(id))//If the item is in the cart
		{
			productList.remove(id);
		}
	}
	session.setAttribute("productList", productList);
%>
<jsp:forward page="showcart.jsp" />