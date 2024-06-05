<%@ page import="java.io.File"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="review.ReviewDAO"%>
<%@ page import="review.Review"%>
<%@ page import="java.io.PrintWriter"%>
<% request.setCharacterEncoding("utf-8"); %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SOF | 리뷰 수정 처리</title>
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
			
			String reviewImgPath = application.getRealPath("/reviewImg/"); // 이미지 저장 경로 
			
			MultipartRequest multi = new MultipartRequest(request, reviewImgPath, 
					100 * 1024 * 1024, "utf-8", new DefaultFileRenamePolicy());
			
			if (multi.getParameter("title").trim().equals(""))
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('제목을 입력해 주세요.')");
				script.println("history.back()");
				script.println("</script>");
			}
			else if (multi.getParameter("content").trim().equals(""))
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('내용을 입력해 주세요.')");
				script.println("history.back()");
				script.println("</script>");
			}
			else
			{
				ReviewDAO reviewDAO = new ReviewDAO();
				int result = reviewDAO.reviewUpdate(no, multi.getParameter("title").trim(), multi.getParameter("content").trim());
				
				if (result == -1)
				{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('리뷰 수정 중 오류가 발생했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				}
				else
				{
					Enumeration files = multi.getFileNames(); // 모든 업로드 이미지 받아오기
					
					while (files.hasMoreElements())
					{
						String image = (String) files.nextElement();
						String fileName = multi.getOriginalFileName(image); // 업로드한 이미지 파일명 (사용자 컴퓨터)
						String fileRealName = multi.getFilesystemName(image); // 저장된 이미지 파일명 (서버)
						String fileType = multi.getContentType(image);
						
						if (fileName == null) // 업데이트 중 파일을 올리지 않으면 업데이트 작업 처리 x
						{
							image = null;
						}
						
						if (fileType == null) // 아무 파일을 올리지 않았을 때
						{
							continue;
						}
						
						if (fileType.equals("image/gif") || fileType.equals("image/png") || fileType.equals("image/jpeg"))
						{						
							switch (image)
							{
								case "img1": // 이미지 1번칸
									// reviewImg폴더에 올라간 이미지 파일 삭제
									reviewDAO.serverImgFileRemove(reviewDAO.getReviewImg(no).get(0), reviewImgPath);					
									// 데이터베이스 reviewimg 테이블 업데이트
									reviewDAO.reviewImgUpdate(no, fileRealName, 1);
									break;
								case "img2": // 이미지 2번칸
									reviewDAO.serverImgFileRemove(reviewDAO.getReviewImg(no).get(1), reviewImgPath);
									reviewDAO.reviewImgUpdate(no, fileRealName, 2);
									break;
								case "img3": // 이미지 3번칸
									reviewDAO.serverImgFileRemove(reviewDAO.getReviewImg(no).get(2), reviewImgPath);
									reviewDAO.reviewImgUpdate(no, fileRealName, 3);
									break;
								case "img4": // 이미지 4번칸
									reviewDAO.serverImgFileRemove(reviewDAO.getReviewImg(no).get(3), reviewImgPath);
									reviewDAO.reviewImgUpdate(no, fileRealName, 4);
									break;
								case "img5": // 이미지 5번칸
									reviewDAO.serverImgFileRemove(reviewDAO.getReviewImg(no).get(4), reviewImgPath);
									reviewDAO.reviewImgUpdate(no, fileRealName, 5);
									break;
							}	
						}
						else
						{
							File file = new File(reviewImgPath + fileRealName);
							file.delete();
							PrintWriter script = response.getWriter();
							script.println("<script>");
							script.println("alert('이미지 파일 형식이 옳지 않습니다.')");
							script.println("history.back()");
							script.println("</script>");
						}
					}
					
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href = '/review/review.jsp?no=" + no + "'");
					script.println("</script>");
				}
			}
		}
	%>
</body>
</html>