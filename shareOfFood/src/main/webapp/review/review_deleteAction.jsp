<%@page import="java.io.File"%>
<%@page import="java.util.ArrayList"%>
<%@page import="review.ReviewDAO"%>
<%@page import="review.Review"%>
<%@page import="java.io.PrintWriter"%>
<% request.setCharacterEncoding("utf-8"); %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SOF | 리뷰 삭제 처리</title>
</head>
<body>
<%	
	int no = 0;

	if (session.getAttribute("userID") == null)
	{
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해 주세요.')");
		script.println("location.href = '/main.jsp'");
		script.println("</script>");
	}
	else
	{
		if (request.getParameter("no") != null)
		{
			no = Integer.parseInt(request.getParameter("no"));
		}
		
		Review review = new ReviewDAO().getReview(no);
		
		if (no == 0 || review == null)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('존재하지 않는 리뷰입니다.')");
			script.println("location.href = '/index.jsp'");
			script.println("</script>");
		}
		
		if (!session.getAttribute("userID").equals(review.getWriter()))
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유저의 정보가 일치하지 않습니다.')");
			script.println("location.href = '/index.jsp'");
			script.println("</script>");
		}
		else
		{		
			ReviewDAO reviewDAO = new ReviewDAO();
			
			ArrayList<String> reviewImgList = reviewDAO.getReviewImg(no);
			String reviewImgPath = application.getRealPath("/reviewImg/");
			
			for (int i = 0; i < reviewImgList.size(); i++)
			{
				if (reviewImgList.get(i) == null)
				{
					continue;
				}
				                 
				File file = new File(reviewImgPath + reviewImgList.get(i));
				file.delete();					
			}
			
			int result = reviewDAO.delete(no);
				
			if (result == -1) // 리뷰 삭제 실패
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('리뷰 삭제 중 오류가 발생했습니다.')");
				script.println("history.back()");
				script.println("</script>");
			}
			else
			{
				result = reviewDAO.deleteImg(no);
				
				if (result == -1)
				{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('리뷰 이미지 삭제 중 오류가 발생했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				}
				else
				{	
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href = '/restaurant/restaurant_view.jsp?no=" + review.getRestNo() + "'");
					script.println("</script>");													
				}
			}
		}
	}
%>
</body>
</html>