<%@ page import="restaurant.RestaurantDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.Enumeration"%>
<%@ page import="java.io.File" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %> <!-- 파일 이름과 관련되어 처리해주는 클래스 -->
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<% request.setCharacterEncoding("utf-8"); %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SOF | 맛집 등록 처리</title>
</head>
<body>
<%
	if (!session.getAttribute("userID").equals("root"))
	{
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('해당 권한이 없습니다.')");
		script.println("location.href = '/index.jsp'");
		script.println("</script>");
	}
	else
	{
		String restaurantImgPath = application.getRealPath("/restaurantImg/"); // 이미지 저장 경로 
		
		MultipartRequest multi = new MultipartRequest(request, restaurantImgPath, 
				100 * 1024 * 1024, "utf-8", new DefaultFileRenamePolicy());
		
		if (multi.getParameter("title").trim().equals(""))
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('음식점 이름을 입력해 주세요.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else if (multi.getParameter("addr").trim().equals(""))
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('음식점 주소를 입력해 주세요.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else if (multi.getParameter("phoneNumber").trim().equals(""))
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('음식점 전화번호를 입력해 주세요.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else if (multi.getParameter("type").trim().equals(""))
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('음식점 분류를 입력해 주세요.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else if (multi.getParameter("price").trim().equals(""))
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('음식점 가격대를 입력해 주세요.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else if (multi.getParameter("businessTime").trim().equals(""))
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('음식점 영업시간을 입력해 주세요.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else if (multi.getParameter("breakTime").trim().equals(""))
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('음식점 휴식시간을 입력해 주세요.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else
		{
			RestaurantDAO restDAO = new RestaurantDAO();
			int result = restDAO.restaurantWrite(multi.getParameter("title").trim(), 
												 multi.getParameter("addr").trim(), 
												 multi.getParameter("phoneNumber").trim(),
												 multi.getParameter("type").trim(),
												 multi.getParameter("price").trim(),
												 multi.getParameter("businessTime").trim(),
												 multi.getParameter("breakTime").trim());
			
			if (result == -1) // 글쓰기 실패 (데이터 베이스 오류 등..)
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('음식점 등록 중 오류가 발생했습니다.')");
				script.println("history.back()");
				script.println("</script>");
			}
			else
			{
				Enumeration files = multi.getFileNames(); // 모든 업로드 이미지 받아오기
				int imgNo = 5;
				
				while (files.hasMoreElements())
				{	
					String image = (String) files.nextElement();
					String fileRealName = multi.getFilesystemName(image); // 저장된 이미지 파일명 (서버)
					String fileType = multi.getContentType(image);
					
					if (fileType == null) // 아무 파일을 올리지 않았을 때
					{
						restDAO.restaurantWriteImg(restDAO.getNo(), null, imgNo); // 데이터베이스에 null로 저장
					}
					else if (fileType.equals("image/gif") || fileType.equals("image/png") || fileType.equals("image/jpeg"))
					{
						restDAO.restaurantWriteImg(restDAO.getNo(), fileRealName, imgNo);
					}
					else
					{
						File file = new File(restaurantImgPath + fileRealName);
						file.delete();
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.println("alert('이미지 파일 형식이 옳지 않습니다.')");
						script.println("</script>");
						restDAO.restaurantWriteImg(restDAO.getNo(), null, imgNo);
					}
					
					imgNo--;
				}
				
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("location.href = '/index.jsp'");
				script.println("</script>");
			}
		}
	}
%>
</body>
</html>