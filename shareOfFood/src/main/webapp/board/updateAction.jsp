<%@ page import="java.io.File"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="board.Board" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("utf-8"); %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SOF | 숨은 맛집 수정 처리</title>
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
			
			Board board = new BoardDAO().getBoard(no);
			
			if (no == 0 || board == null)
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('존재하지 않는 게시물입니다.')");
				script.println("location.href = '/board/list.jsp'");
				script.println("</script>");
			}		
			
			if (!session.getAttribute("userID").equals(board.getWriter()) && !session.getAttribute("userID").equals("root"))
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('유저의 정보가 일치하지 않습니다.')");
				script.println("location.href = '/board/list.jsp'");
				script.println("</script>");
			}
			
			String boardImgPath = application.getRealPath("/img/"); // 이미지 저장 경로 
			
			MultipartRequest multi = new MultipartRequest(request, boardImgPath, 
					100 * 1024 * 1024, "utf-8", new DefaultFileRenamePolicy());
			
			if (multi.getParameter("title").trim().equals("")) // 글 수정에서 제목을 입력 안 했을 시
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('제목을 입력해 주세요.')");
				script.println("history.back()");
				script.println("</script>");
			}
			else if (multi.getParameter("addr").trim().equals("")) // 주소을 입력 안 했을 시
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('주소를 입력해 주세요.')");
				script.println("history.back()");
				script.println("</script>");
			}
			else if (multi.getParameter("type").trim().equals("")) // 분류를 입력 안 했을 시
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('분류를 입력해 주세요.')");
				script.println("history.back()");
				script.println("</script>");
			}
			else if (multi.getParameter("price").trim().equals("")) // 가격을 입력 안 했을 시
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('가격을 입력해 주세요.')");
				script.println("history.back()");
				script.println("</script>");
			}
			else if (multi.getParameter("content").trim().equals("")) // 글 수정에서 내용을 입력 안 했을 시
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('내용을 입력해 주세요.')");
				script.println("history.back()");
				script.println("</script>");
			}
			else
			{
				BoardDAO boardDAO = new BoardDAO();
				int result = boardDAO.boardUpdate(no, multi.getParameter("title").trim(), multi.getParameter("addr").trim(), multi.getParameter("type").trim(),
												  multi.getParameter("price").trim(), multi.getParameter("content").trim());
				
				if (result == -1) // 글 수정 실패
				{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글 수정 중 오류가 발생했습니다.')");
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
									// img폴더에 올라간 이미지 파일 삭제
									boardDAO.serverImgFileRemove(boardDAO.getBoardImg(no).get(0), boardImgPath);					
									// 데이터베이스 boardimg 테이블 업데이트
									boardDAO.boardImgUpdate(no, fileRealName, 1);
									break;
								case "img2": // 이미지 2번칸
									// img폴더에 올라간 이미지 파일 삭제
									boardDAO.serverImgFileRemove(boardDAO.getBoardImg(no).get(1), boardImgPath);
									// 데이터베이스 boardimg 테이블 업데이트
									boardDAO.boardImgUpdate(no, fileRealName, 2);
									break;
								case "img3": // 이미지 3번칸
									// img폴더에 올라간 이미지 파일 삭제
									boardDAO.serverImgFileRemove(boardDAO.getBoardImg(no).get(2), boardImgPath);
									// 데이터베이스 boardimg 테이블 업데이트
									boardDAO.boardImgUpdate(no, fileRealName, 3);
									break;
								case "img4": // 이미지 4번칸
									// img폴더에 올라간 이미지 파일 삭제
									boardDAO.serverImgFileRemove(boardDAO.getBoardImg(no).get(3), boardImgPath);
									// 데이터베이스 boardimg 테이블 업데이트
									boardDAO.boardImgUpdate(no, fileRealName, 4);
									break;
								case "img5": // 이미지 5번칸
									// img폴더에 올라간 이미지 파일 삭제
									boardDAO.serverImgFileRemove(boardDAO.getBoardImg(no).get(4), boardImgPath);
									// 데이터베이스 boardimg 테이블 업데이트
									boardDAO.boardImgUpdate(no, fileRealName, 5);
									break;
							}	
						}
						else
						{
							File file = new File(boardImgPath + fileRealName);
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
					script.println("location.href = '/board/view.jsp?no=" + no + "'");
					script.println("</script>");
				}
			}
		}
	%>
</body>
</html>