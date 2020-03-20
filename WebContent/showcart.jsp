<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>Your Dream Vine Shopping Cart</title>
</head>
<body>
	<%
		// Get the current list of products
		@SuppressWarnings({"unchecked"})
		HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
		
		if(productList==null||productList.isEmpty()){
			out.print("<h1>Your Shopping Cart is empty!</h1>");
			productList = new HashMap<String, ArrayList<Object>>();
		}else {
			NumberFormat currFormat = NumberFormat.getCurrencyInstance();
		
			out.print("<h1>Your Shopping Cart</h1>");
			out.print("<table style='border-collapse: collapse'><tr style='background-color:#243743'><th style='background-color:#243743'>Product Id</th><th style='background-color:#243743'>Product Name</th><th style='background-color:#243743'>Quantity</th>");
			out.print("<th style='background-color:#243743'>Price</th><th style='text-align:right; background-color:#243743'>Subtotal</th></tr>");
		
			double total =0;
			Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
			while (iterator.hasNext()) {
				Map.Entry<String, ArrayList<Object>> entry = iterator.next();
				ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
				if (product.size() < 4) {
					out.print("Expected product with four entries. Got: "+product);
					continue;
				}
				
				out.print("<tr><td>"+product.get(0)+"</td>");
				out.print("<td>"+product.get(1)+"</td>");
		
	//			out.print("<td align=\"center\">"+product.get(3)+"</td>"); //Get rid of this?
				
				//Added from Tatiana for update cart quantity - START
				String addCartLink = "addcart.jsp?id=" + product.get(0) + "&name=" + product.get(1) + "&price=" + product.get(2);
				
				out.print("<td align='center'><form method='post' action='" + addCartLink + "' autocomplete='off' style='color:black'>");
				out.print("<input type='number' name='newqty' min='1' max='50' placeholder='"+product.get(3)+"'>");
				out.print("<input type='submit' name='Submit2' value='Update quantity'></form>");
				//Added from Tatiana for update cart quantity - END
				
				
				Object price = product.get(2);
				Object itemqty = product.get(3);
				double pr = 0;
				int qty = 0;
				
				try	{
					pr = Double.parseDouble(price.toString());
				}catch (Exception e) {
					out.println("<p>Invalid price for product: "+product.get(0)+" price: "+price+"</p>");
				}
				try	{
					qty = Integer.parseInt(itemqty.toString());
				} catch (Exception e) {
					out.println("Invalid quantity for product: "+product.get(0)+" quantity: "+qty);
				}		
		
				out.print("<td align=\"right\">"+currFormat.format(pr)+"</td>");
				out.print("<td align=\"right\">"+currFormat.format(pr*qty)+"</td>");
				
				String removeCartLink = "removecart.jsp?id=" + product.get(0);
				
				out.print("<td valign='top'><button onclick=\"window.location.href=\'"+ removeCartLink +"\'\">Remove from cart</button></td></tr>");
				total = total + pr * qty;
			}
			out.print("<tr style='background-color:#243743'><td colspan='4' align='right'><b>Order Total</b></td>"
					+"<td align='right'><b>"+currFormat.format(total)+"</b></td></tr>");
			out.print("</table><br>");
			out.print("<a href='checkout.jsp'><button>Check Out</button></a>");
		}
	%>
	<a href="listprod.jsp"><button>Continue Shopping</button></a>

</body>
</html> 

