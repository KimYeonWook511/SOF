<%@ page import="java.util.ArrayList"%>
<%@ page import="board.Board"%>
<%@ page import="board.BoardDAO"%>
<%@ page import="java.io.PrintWriter"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SOF | 숨은 맛집 수정 하기</title>
<!-- 라이브러리 등록 - jQuery, Bootstrap : CDN 방식-->
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<!-- 카카오 지도 api -->
<script 
    type="text/javascript" 
    src="//dapi.kakao.com/v2/maps/sdk.js?appkey=28e05f70686110a899f17cd6caf1e542&libraries=services"></script>
<!-- 음식점 정보 css -->
<link rel="stylesheet" href="/css/board.css">
<link rel="stylesheet" href="/css/navbar.css">
</head>
<body>
<%
	int no = 0;
	String userID = (String)session.getAttribute("userID");
	
	if (request.getParameter("no") != null)
	{
		no = Integer.parseInt(request.getParameter("no"));
	}

	Board board = new BoardDAO().getBoard(no);
	
	if ((userID == null || !userID.equals(board.getWriter())) && !userID.equals("root"))
	{
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('해당 권한이 없습니다.')");
		script.println("location.href = '/index.jsp'");
		script.println("</script>");
	}
	
	ArrayList<String> boardImgList = new BoardDAO().getBoardImg(no);
	
	if (no == 0 || board == null)
	{
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('존재하지 않는 숨은 맛집 리뷰입니다.')");
		script.println("location.href = '/index.jsp'");
		script.println("</script>");
	}
	else
	{
		request.setAttribute("no", no);
		request.setAttribute("board", board);
		request.setAttribute("boardImgList", boardImgList);
%>
	<jsp:include page="/layout/navbar.jsp" flush="false"/>
	<form action="/board/updateAction.jsp?no=${no }" method="post" enctype="multipart/form-data">
		<table class="board_imgFile">
				<tr>
					<td><input type="file" name="img1" accept="image/gif, image/png, image/jpeg" class="file_input"></td>
					<td><input type="file" name="img2" accept="image/gif, image/png, image/jpeg" class="file_input"></td>
					<td><input type="file" name="img3" accept="image/gif, image/png, image/jpeg" class="file_input"></td>
					<td><input type="file" name="img4" accept="image/gif, image/png, image/jpeg" class="file_input"></td>
					<td><input type="file" name="img5" accept="image/gif, image/png, image/jpeg" class="file_input"></td>
				</tr>
			</table>
		<div class="board_imgMain">
			<c:forEach var="boardimg" items="${boardImgList }">
				<c:if test="${boardimg != null }">
					<span class="board_img" style="display: table-cell; text-align: center; vertical-align: middle;"><img class="board_imgtag" src="/img/${boardimg }"></span>
				</c:if>
				<c:if test="${boardimg == null }">
					<span class="board_img" style="display: table-cell; text-align: center; vertical-align: middle;">미리보기</span>
				</c:if>
			</c:forEach>
		</div>
		<hr>
		<div class="main">
			<div class="column-main">
				<div class="board-title">
					<div class="board-name" style="font-size: 20px;">
						숨은 맛집 게시판 제목<br>
						<input type="text" name="title" maxlength="50" style="width: 800px; height: 30px;" value="${board.getTitle() }">
					</div>
					<div class="board-status">
						<div class="status-viewCount">조회수 : ${board.getViewCount() }</div>
						<div class="status-write">
							<span class="status-writer">작성자 : ${board.getWriter() }</span>
							<span class="status-writeDate">작성일 : ${board.getWriteDate() }</span>
						</div>
						<hr class="hr-bar">
					</div>
				</div>
				<div class="board-info">
					<table class="info-table">
						<tr>
							<th class="board_info_th">주소</th>
							<td>
								<input type="text" name="addr" id="searchMap" placeholder="ex)인천광역시 미추홀구 용현동 191-93" style="width: 500px; height: 30px;" value="${board.getAddr() }">
								<button id="searchBtn" class="btn btn-default" type="button">검색</button>
							</td>
						</tr>
						<tr>
							<th class="board_info_th">분류</th>
							<td><input type="text" name="type" placeholder="ex)면, 국수" maxlength="50" style="width: 500px; height: 30px;" value="${board.getType() }"></td>
						</tr>
						<tr>
							<th class="board_info_th">가격</th>
							<td><input type="text" name="price" placeholder="ex)4000원 ~ 8000원" maxlength="50" style="width: 500px; height: 30px;" value="${board.getPrice() }"></td>
						</tr>
						<tr>
							<th class="board_info_th">소개내용</th>
							<td><textarea rows="20" cols="100" name="content" maxlength="5000">${board.getContent() }</textarea></td>
						</tr>
						<tr>
							<td colspan="2"><button class="btn btn-default pull-right">숨은 맛집 수정</button></td>
						</tr>
					</table>
				</div>	
			</div>
			<div class="column-side">
				<div id="map" style="width:400px;height:400px;"></div>
			</div>
		</div>
	</form>
	<script>
		$(document).ready(function(){
			updateSideMap("<%=board.getAddr()%>");
			var h = 350;
			var w = ($(window).width())/5-5;
			$('.board_imgFile').css({width:$(window).width()+'px'});
			$('.file_input').css({width:w+'px'});
			$('.board_imgMain').css({height:h+'px', width:$(window).width()+'px'});
			$('.board_img').css({height:h+'px', width:w+'px'});
			$('.board_imgtag').css({height:h+'px', width:w+'px'});
		});
	</script>
	<script>
		let input = document.querySelectorAll('[type="file"]');
		let preview = document.querySelectorAll('.board_img');
		for(let i=0; i<input.length; i++) {
		    input[i].addEventListener('change', function(e) {
		        let file = e.target.files;
		        if(file.length) {
		            let reader = new FileReader();
		            reader.readAsDataURL(file[0]);
		            reader.onload = function() {
		                let dataUrl = reader.result;
		                preview[i].innerHTML = '<img src="' + dataUrl + '" style="height:'+ $('.board_img').height() +'px; width:'+ $('.board_img').width() +'px;">';
		            }
		        } else {
		            preview[i].innerHTML = '미리보기';
		        }
		    })
		}
	</script>
	<script src="/maps/searchMap.js"></script>
	<%
		}
	%>
	<jsp:include page="/layout/footer.jsp"></jsp:include>
</body>
</html>