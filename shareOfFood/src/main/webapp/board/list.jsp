<%@ page import="board.Board" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="java.util.ArrayList" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SOF | 숨은 맛집 리스트</title>
<!-- 라이브러리 등록 - jQuery, Bootstrap : CDN 방식-->
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="/css/boardList.css">
</head>
<body>
	<%
		int pageNumber = 1 ; // 첫 페이지
		
		if (request.getParameter("pageNumber") != null)
		{
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}
		
		BoardDAO boardDAO = new BoardDAO();
		ArrayList<Board> boardList = boardDAO.getList(pageNumber);
		int boardTotal = boardDAO.getNext() - 1; // 다음 게시글 번호에서 1을 빼야 총 게시글의 수
		
		request.setAttribute("pageNumber", pageNumber);
		request.setAttribute("boardDAO", boardDAO);
		request.setAttribute("boardList", boardList);
		request.setAttribute("boardTotal", boardTotal);
	%>
	<jsp:include page="/layout/navbar.jsp" flush="false"/>
	<div class="container">
		<div class="board-list">
			<div class="board-header">
				<div>
					숨은 맛집 게시판 (${boardTotal })
					<button type="button" class="btn btn-default pull-right" onclick="location.href = '/board/writeForm.jsp'">글쓰기</button>
				</div>
			</div>
		</div>
		<c:if test="${boardList.size() == 0 }">
			<div class="board-main">
				<hr style="margin-top: 0px; margin-bottom: 15px; width: 1140px">
				<div style="font-size:30px; font-weight: bold; color: rgba(79,79,79,0.6);">숨은 맛집 게시글이 존재하지 않습니다.</div>
			</div>
		</c:if>
		<c:if test="${boardList.size() != 0 }">
			<div class="board-main">
				<table class="table" style="margin-bottom: 0px;">
					<tr>
						<th style="width: 150px; text-align: center;">작성자</th>
						<th style="text-align: center;">제목</th>
						<th style="width: 100px; text-align: center;">조회수</th>
						<th style="width: 100px; text-align: center;">작성일</th>
					</tr>
				</table>
				<hr style="margin-top: 0px; margin-bottom: 0px; width: 1140px">
			</div>
			<c:forEach var="board" items="${boardList }">
				<div class="board-data">
					<input type="hidden" class="no" value="${board.getNo()}">
					<div class="board-writer">
						<div class="board-writer-inner">
							${board.getWriter() }
						</div>
					</div>
					<div class="board-info">
						<div class="board-title">
							${board.getTitle() }
						</div>					
						${flag = false;'' }
						<c:forEach var="boardImg" items="${boardDAO.getBoardImg(board.getNo()) }">
							<c:if test="${boardImg != null }">
								${flag = true;'' }
							</c:if>
						</c:forEach>
						<c:if test="${flag == true }"> <!-- 리뷰 사진이 있을 경우 영역 생성 -->
							<div class="board-img-list">
								<div class="board-imgMain">
									<c:forEach var="boardImg" items="${boardDAO.getBoardImg(board.getNo()) }" varStatus="status">
										<c:if test="${boardImg == null }">
										</c:if>
										<c:if test="${boardImg != null }">
											<span class="board-img">
												<img class="board-imgtag" src="/img/${boardImg }" style="padding: 10px 15px 0 0;">
											</span>											
										</c:if>
									</c:forEach>							
								</div>
							</div>					
						</c:if>												
					</div>
					<div class="board-viewCount">
						${board.getViewCount() }
					</div>
					<div class="board-date">
						${board.getWriteDate() }
					</div>
				</div>
				<hr style="margin-top: 0px; margin-bottom: 0px; width: 1140px">			
			</c:forEach>	
		</c:if>
		<br>
		<div class="lowArea">
			<select id="searchVal" name="searchVal" class="searchSelect">
				<option value="전체" selected>전체</option>
				<option value="제목">제목</option>
				<option value="주소">주소</option>
				<option value="분류">분류</option>
				<option value="소개내용">소개내용</option>
				<option value="작성자">작성자</option>
			</select>
			<input type="text" class="search_board" placeholder="검색">
			<a class="searchImg"></a>
			<div class="boardBtn">
				<a href="/board/writeForm.jsp" class="btn btn-default pull-right">글쓰기</a>
				<a href="/board/list.jsp" class="btn btn-default pull-right">목록</a>
				<c:if test="${!boardDAO.lastPage(pageNumber) }">
					<a href="/board/list.jsp?pageNumber=${pageNumber + 1 }" class="btn btn-default pull-right">다음</a>
				</c:if>
				<c:if test="${pageNumber != 1 }">
					<a href="/board/list.jsp?pageNumber=${pageNumber - 1 }" class="btn btn-default pull-right">이전</a>
				</c:if>
			</div>
		</div>
	</div>
	<jsp:include page="/layout/footer.jsp"></jsp:include>
	<script>
		var selectVal = document.getElementById("searchVal");
	
		$(document).ready(function(){
			var h = 100;
			var w = 100;
			$('.board-imgtag').css({height:h+'px', width:w+'px'});
		});
		
		$(function() { // onready - html의 body 부분의 내용이 다 로딩되면 동작되도록 한다.
			// 데이터 한줄 클릭하면 글보기로 이동되는 이벤트 처리
			$(".board-data").click(function() { // board-data 클래스가 클릭되면 function 실행
				location = '/board/view.jsp?no=' + $(this).find(".no").val();
			})
		});

	 	$(document).ready(function() {
	        $(".search_board").keydown(function(key) {
	            if (key.keyCode == 13) {
	            	location.href = '/board/searchList.jsp?selected=' + selectVal.options[selectVal.selectedIndex].value + '&search=' + document.querySelector('.search_board').value;
	        	}
	        });
        });
	 	
	 	$(function() {
			$(".searchImg").click(function() {
				location.href = '/board/searchList.jsp?selected=' + selectVal.options[selectVal.selectedIndex].value + '&search=' + document.querySelector('.search_board').value;
			})
		});
	</script>
</body>
</html>