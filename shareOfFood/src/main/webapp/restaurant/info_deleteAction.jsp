<%@ page import="java.io.File" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="restaurant.Restaurant" %>
<%@ page import="restaurant.RestaurantDAO" %>
<%@ page import="review.Review" %>
<%@ page import="review.ReviewDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("utf-8"); %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SOF | 맛집 삭제 처리</title>
</head>
<body>
<%	
	int no = 0;
	String userID = (String)session.getAttribute("userID");
	
	if (request.getParameter("no") != null)
	{
		no = Integer.parseInt(request.getParameter("no"));
	}
	
	if (userID == null || !userID.equals("root"))
	{
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('해당 권한이 없습니다.')");
		script.println("location.href = '/index.jsp'");
		script.println("</script>");
	}
	else
	{	
		Restaurant rest = new RestaurantDAO().getRestaurant(no);
		
		if (no == 0 || rest == null)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('존재하지 않는 음식점입니다.')");
			script.println("location.href = '/index.jsp'");
			script.println("</script>");
		}
		
				
		RestaurantDAO restDAO = new RestaurantDAO();
			
		ArrayList<String> restImgList = restDAO.getRestaurantImg(no);
		String restaurantImgPath = application.getRealPath("/restaurantImg/");
		
		for (int i = 0; i < restImgList.size(); i++)
		{
			if (restImgList.get(i) == null)
			{
				continue;
			}
			                 
			File file = new File(restaurantImgPath + restImgList.get(i));
			file.delete();					
		}
		
		int result = restDAO.delete(no);
			
		if (result == -1) // 글 삭제 실패
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('맛집 삭제 중 오류가 발생했습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else
		{
			result = restDAO.deleteImg(no);
			
			if (result == -1)
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('맛집 이미지 삭제 중 오류가 발생했습니다.')");
				script.println("history.back()");
				script.println("</script>");
			}
			else
			{	
				ArrayList<Review> reviewList = new ReviewDAO().getReviewList(no);
				
				for (int i = 0; i < reviewList.size(); i++)
				{
					result = new ReviewDAO().delete(reviewList.get(i).getNo());
					
					if (result == -1)
					{
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.println("alert('리뷰 삭제 중 오류가 발생했습니다.')");
						script.println("history.back()");
						script.println("</script>");
					}
					else
					{
						result = new ReviewDAO().deleteImg(reviewList.get(i).getNo());
						
						if (result == -1)
						{
							PrintWriter script = response.getWriter();
							script.println("<script>");
							script.println("alert('리뷰 이미지 삭제 중 오류가 발생했습니다.')");
							script.println("history.back()");
							script.println("</script>");
						}
					}
				}
				
				result = restDAO.deleteRestLike(no);
				
				if (result == -1)
				{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('맛집 좋아요 삭제 중 오류가 발생했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				}
				else
				{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href = '/index.jsp'");
					script.println("</script>");
				}													
			}
		}
	}	
%>
</body>
</html>