<%@ page import="java.io.File"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="restaurant.Restaurant" %>
<%@ page import="restaurant.RestaurantDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("utf-8"); %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SOF | 맛집 수정 처리</title>
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
		
		Restaurant rest = new RestaurantDAO().getRestaurant(no);
		
		if (no == 0 || rest == null)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('존재하지 않는 음식점입니다.')");
			script.println("location.href = '/index.jsp'");
			script.println("</script>");
		}
			
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
				int result = restDAO.restaurantUpdate(no,
													  multi.getParameter("title").trim(), 
													  multi.getParameter("addr").trim(), 
													  multi.getParameter("phoneNumber").trim(),
													  multi.getParameter("type").trim(),
													  multi.getParameter("price").trim(),
													  multi.getParameter("businessTime").trim(),
													  multi.getParameter("breakTime").trim());
				
				if (result == -1) // 음식점 수정 실패
				{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('음식점 수정 중 오류가 발생했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				}
				else
				{
					// 플젝 게시판 수정에서 이미지 비교해서 삭제하는거, 게시판 삭제되면 서버에서도 이미지 삭제하기
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
									// restaurantImg폴더에 올라간 이미지 파일 삭제
									restDAO.serverImgFileRemove(restDAO.getRestaurantImg(no).get(0), restaurantImgPath);					
									// 데이터베이스 restaurantimg 테이블 업데이트
									restDAO.restaurantImgUpdate(no, fileRealName, 1);
									break;
								case "img2": // 이미지 2번칸
									// restaurantImg폴더에 올라간 이미지 파일 삭제
									restDAO.serverImgFileRemove(restDAO.getRestaurantImg(no).get(1), restaurantImgPath);
									// 데이터베이스 restaurantimg 테이블 업데이트
									restDAO.restaurantImgUpdate(no, fileRealName, 2);
									break;
								case "img3": // 이미지 3번칸
									// restaurantImg폴더에 올라간 이미지 파일 삭제
									restDAO.serverImgFileRemove(restDAO.getRestaurantImg(no).get(2), restaurantImgPath);
									// 데이터베이스 restaurantimg 테이블 업데이트
									restDAO.restaurantImgUpdate(no, fileRealName, 3);
									break;
								case "img4": // 이미지 4번칸
									// restaurantImg폴더에 올라간 이미지 파일 삭제
									restDAO.serverImgFileRemove(restDAO.getRestaurantImg(no).get(3), restaurantImgPath);
									// 데이터베이스 restaurantimg 테이블 업데이트
									restDAO.restaurantImgUpdate(no, fileRealName, 4);
									break;
								case "img5": // 이미지 5번칸
									// restaurantImg폴더에 올라간 이미지 파일 삭제
									restDAO.serverImgFileRemove(restDAO.getRestaurantImg(no).get(4), restaurantImgPath);
									// 데이터베이스 restaurantimg 테이블 업데이트
									restDAO.restaurantImgUpdate(no, fileRealName, 5);
									break;
							}	
						}
						else
						{
							File file = new File(restaurantImgPath + fileRealName);
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
					script.println("location.href = '/index.jsp'");
					script.println("</script>");
				}
			}
	%>
</body>
</html>