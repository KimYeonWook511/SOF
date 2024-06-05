package board;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;

//데이터베이스와 1:1 연동
public class BoardDAO { // Database Access Object 데이터 접근 객체
	Connection conn;
	int no;

	public BoardDAO() // MySQL 접속하는 부분
	{
		try 
		{
			String driver = "com.mysql.jdbc.Driver";
			String dbURL = "jdbc:mysql://localhost:3306/board"; // board라는 데이터 베이스
			String dbID = "root";
			String dbPassword = "root";
			
			// 1. 드라이버 확인
			Class.forName(driver);
			// 2. 연결
			this.conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
	}

	public String getDate() 
	{
		//현재의 시간을 가져오는 mysql 문장
		String SQL = "select now()";
		
		try 
		{
			// pstmt 실행 객체 / conn 객체를 이용해서 SQL문장을 실행준비단계로 만듬
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			ResultSet rs = pstmt.executeQuery(); // 실제로 실행했을때의 결과
			
			if (rs.next())
			{
				return rs.getString(1);				
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		
		return "Database Error";
	}

	public int getNext() 
	{
		// 내림차순을 해서 제일 마지막에 쓰인 글 번호를 가져올 것
		String SQL = "select no from board order by no desc";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL); // conn 객체를 이용해서 SQL문장을 실행준비단계로 만듬
			ResultSet rs = pstmt.executeQuery(); // 실제로 실행했을때의 결과
			
			if (rs.next())
			{
				return rs.getInt("no") + 1; // 내림차순 후 맨 위 게시글 번호 가져온 뒤 + 1				
			}
			
			return 1; // 게시물이 없는 경우(첫 게시물)
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return -1; // 데이터베이스 오류
		}
	}

	public int boardWrite(String title, String addr, String type, String price, String content, String writer) 
	{
		String SQL = "insert into board values (?, ?, ?, ?, ?, ?, ?, ?, ?)";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL); // conn 객체를 이용해서 SQL문장을 실행준비단계로 만듬
			pstmt.setInt(1, this.no = getNext()); // getNext() 함수 호출 (게시글 번호)
			pstmt.setString(2, title); // 파라미터(매개변수) title
			pstmt.setString(3, addr); // 파라미터(매개변수) addr
			pstmt.setString(4, type); // 파라미터(매개변수) type
			pstmt.setString(5, price); // 파라미터(매개변수) price
			pstmt.setString(6, content); // 파라미터(매개변수) content
			pstmt.setString(7, writer); // 파라미터(매개변수) writer
			pstmt.setString(8, getDate()); // getDate() 함수 호출 (날짜)
			pstmt.setInt(9, 0); // 조회수
			
			return pstmt.executeUpdate(); // 성공적으로 insert, update, delete 시 0이상의 결과를 반환함
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return -1; //데이터베이스 오류
		}
	}

	public int boardWriteImg(int no, String fileRealName, int imgNo) 
	{
		String SQL = "insert into boardimg values (?, ?, ?)";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setInt(1, no);
			pstmt.setString(2, fileRealName);
			pstmt.setInt(3, imgNo);
			return pstmt.executeUpdate();
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return -1; //데이터베이스 오류
		}
	}

	public ArrayList<Board> getList(int pageNumber) 
	{
		String SQL = "select * from board where no < ? order by no desc limit 15"; // limit 15는 위에서 15개만 가져올 수 있게 함
		ArrayList<Board> list = new ArrayList<>();
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL); // conn 객체를 이용해서 SQL문장을 실행준비단계로 만듬
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 15); /*
																 * getNext() = 다음 글의 번호 
																 * 만약 게시글이 13개이고 1페이지면 no < 14 해서 13개의 목록만 가져옴
																 * 만약 게시글이 24개이고 2페이지면 no < (25 - 15) 해서 9개의 목록만 가져옴 
																 */
			ResultSet rs = pstmt.executeQuery(); // 쿼리문 결과
			
			while (rs.next()) 
			{
				Board board = new Board();
				board.setNo(rs.getInt("no"));
				board.setTitle(rs.getString("title"));
				board.setAddr(rs.getString("addr"));
				board.setType(rs.getString("type"));
				board.setPrice(rs.getString("price"));
				board.setContent(rs.getString("content"));
				board.setWriter(rs.getString("writer"));
				board.setWriteDate(rs.getString("writeDate"));
				board.setViewCount(rs.getInt("viewCount"));
				list.add(board);
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return list;
	}
	
	public ArrayList<Board> getSearchList(int pageNumber,String selected, String search)
	{
		String concat = "concat문";
		
		if (selected.equals("전체"))
		{
			concat = " concat(title, addr, type, content, writer) ";
		}
		else if (selected.equals("제목"))
		{
			concat = " concat(title) ";
		}
		else if (selected.equals("주소"))
		{
			concat = " concat(addr) ";
		}
		else if (selected.equals("분류"))
		{
			concat = " concat(type) ";
		}
		else if (selected.equals("소개내용"))
		{
			concat = " concat(content) ";
		}
		else if (selected.equals("작성자"))
		{
			concat = " concat(writer) ";
		}
		else
		{
			return null;
		}
		
		String SQL = "select * from board where" + concat + "like ? order by no desc";
		ArrayList<Board> list = new ArrayList<>();
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setString(1, "%" + search + "%");
			ResultSet rs = pstmt.executeQuery();
			int rsCnt = 0; // 쿼리문 결과 카운트 수
			
			while (rs.next())
			{
				rsCnt++;
				
				if (pageNumber * 15 >= rsCnt && (pageNumber - 1) * 15 < rsCnt)
				{
					Board board = new Board();
					board.setNo(rs.getInt("no"));
					board.setTitle(rs.getString("title"));
					board.setAddr(rs.getString("addr"));
					board.setType(rs.getString("type"));
					board.setPrice(rs.getString("price"));
					board.setContent(rs.getString("content"));
					board.setWriter(rs.getString("writer"));
					board.setWriteDate(rs.getString("writeDate"));
					board.setViewCount(rs.getInt("viewCount"));
					list.add(board);					  
				}
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return list;
	}
	
	public int getSearchTotal(String selected, String search)
	{
		// 검색된 게시글의 총 개수
		String concat = "concat문";
		
		if (selected.equals("전체"))
		{
			concat = " concat(title, addr, type, content, writer) ";
		}
		else if (selected.equals("제목"))
		{
			concat = " concat(title) ";
		}
		else if (selected.equals("주소"))
		{
			concat = " concat(addr) ";
		}
		else if (selected.equals("분류"))
		{
			concat = " concat(type) ";
		}
		else if (selected.equals("소개내용"))
		{
			concat = " concat(content) ";
		}
		else if (selected.equals("작성자"))
		{
			concat = " concat(writer) ";
		}
		else
		{
			return -1;
		}
		
		String SQL = "select * from board where" + concat + "like ?";
		
		try
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setString(1, "%" + search + "%");
			ResultSet rs = pstmt.executeQuery();
			int total = 0;
			
			while (rs.next())
			{
				total++;		
			}
			
			return total;
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return -2; // 데이터베이스 오류
		}		
	}
	
	public boolean lastSearchPage(int pageNumber, String selected, String search)
	{
		String concat = "concat문";
		
		if (selected.equals("전체"))
		{
			concat = " concat(title, addr, type, content, writer) ";
		}
		else if (selected.equals("제목"))
		{
			concat = " concat(title) ";
		}
		else if (selected.equals("주소"))
		{
			concat = " concat(addr) ";
		}
		else if (selected.equals("분류"))
		{
			concat = " concat(type) ";
		}
		else if (selected.equals("소개내용"))
		{
			concat = " concat(content) ";
		}
		else if (selected.equals("작성자"))
		{
			concat = " concat(writer) ";
		}
		
		String SQL = "select * from board where" + concat + "like ? order by no desc";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setString(1, "%" + search + "%");
			ResultSet rs = pstmt.executeQuery();
			int rsCnt = 0; // 쿼리문 결과 카운트 수
			
			while (rs.next())
			{
				rsCnt++;
			}
			
			if (pageNumber * 15 < rsCnt)
			{
				return false; // 검색에서 마지막 페이지 아님
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return true; // 검색에서 마지막 페이지임
	}
	
	public boolean lastPage(int pageNumber) // 마지막 페이지 확인 메소드
	{
		String SQL = "select * from board where no < ? order by no desc limit 15";
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL); // conn 객체를 이용해서 SQL문장을 실행준비단계로 만듬
			pstmt.setInt(1, getNext() - pageNumber * 15);
			ResultSet rs = pstmt.executeQuery(); // 쿼리문 결과
			
			if (rs.next())
			{
				return false; // 마지막 페이지가 아님 // 마지막 페이지가 아님
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return true; // 마지막 페이지임
	}

	public Board getBoard(int no) 
	{
		String SQL = "select * from board where no = ?";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setInt(1, no);
			ResultSet rs = pstmt.executeQuery();
			
			if (rs.next()) 
			{
				Board board = new Board();
				board.setNo(rs.getInt("no"));
				board.setTitle(rs.getString("title"));
				board.setAddr(rs.getString("addr"));
				board.setType(rs.getString("type"));
				board.setPrice(rs.getString("price"));
				board.setContent(rs.getString("content"));
				board.setWriter(rs.getString("writer"));
				board.setWriteDate(rs.getString("writeDate"));
				board.setViewCount(rs.getInt("viewCount"));
				
				return board;
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return null; // 해당 번호의 글이 존재하지 않을 때
	}

	public ArrayList<String> getBoardImg(int no) 
	{
		String SQL = "select * from boardimg where no = ?";
		ArrayList<String> boardImgList = new ArrayList<>();
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setInt(1, no);
			ResultSet rs = pstmt.executeQuery();
			
			while (rs.next())
			{
				boardImgList.add(rs.getString(2));
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		Collections.reverse(boardImgList); // 리스트 순서 뒤집기
		return boardImgList;
	}

	public int upViewCount(int no, int viewCount)
	{
		String SQL = "update board set viewCount = ? where no = ?";
		
		try 
		{			
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setInt(1, viewCount + 1);
			pstmt.setInt(2, no);
			
			return pstmt.executeUpdate();
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return -1;
		}
	}
	
	public int boardUpdate(int no, String title, String addr, String type, String price, String content) 
	{
		String SQL = "update board set title = ?, addr = ?, type = ?, price = ?, content = ? where no = ?";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setString(1, title);
			pstmt.setString(2, addr);
			pstmt.setString(3, type);
			pstmt.setString(4, price);
			pstmt.setString(5, content);
			pstmt.setInt(6, no);
			
			return pstmt.executeUpdate();
		}
		catch (Exception e) 
		{
			e.printStackTrace();
			return -1;
		}
	}

	public int boardImgUpdate(int no, String fileRealName, int imgNo) 
	{
		String SQL = "update boardimg set fileRealName = ? where no = ? and imgNo = ?";
		
		try
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setString(1, fileRealName);
			pstmt.setInt(2, no);
			pstmt.setInt(3, imgNo);

			return pstmt.executeUpdate();
		}
		catch (Exception e)
		{
			e.printStackTrace();
			return -1;
		}
	}

	public void serverImgFileRemove(String preFileRealName, String boardImgPath)
	{
		if (preFileRealName == null)
		{
			return;
		}
		
		File file = new File(boardImgPath + preFileRealName);
		file.delete();
	}

	public int delete(int no) 
	{
		String SQL = "delete from board where no = ?";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setInt(1, no);
			
			return pstmt.executeUpdate();
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return -1;
		}
	}

	public int deleteImg(int no) 
	{
		String SQL = "delete from boardimg where no = ?";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setInt(1, no);
			
			return pstmt.executeUpdate();
		} 
		catch (Exception e)
		{
			e.printStackTrace();
			return -1;
		}
	}

	public int refreshNo(int no) // 게시글 삭제 후 게시글 번호 새로고침
	{
		String SQL = "update board set no = ? where no = ?";
		
		if (no == getNext() + 1) return 0; // 삭제한 게시글이 마지막 번호였을 때 무반응
		
		try 
		{
			for (int i = 0; i < getNext() - no; i++) 
			{
				PreparedStatement pstmt = this.conn.prepareStatement(SQL);
				pstmt.setInt(1, no + i);
				pstmt.setInt(2, no + i + 1);
				pstmt.executeUpdate();
			}
			return 1;
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return -1;
		}
	}

	public int refreshImgNo(int no) 
	{
		String SQL = "update boardimg set no = ? where no = ?";
		
		if (no == getNext() + 1) return 0; // 삭제한 게시글이 마지막 번호였을 때 무반응
		try 
		{
			for (int i = 0; i < getNext() - no; i++) 
			{
				PreparedStatement pstmt = this.conn.prepareStatement(SQL);
				pstmt.setInt(1, no + i);
				pstmt.setInt(2, no + i + 1);
				pstmt.executeUpdate();
			}
			return 1;
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return -1;
		}
	}

	public int getNo() 
	{
		return this.no;
	}
	
	public ArrayList<Board> getHotBoardList()
	{
		String SQL = "select * from board order by viewCount desc limit 6"; // 6개의 게시글만 가져오기
		ArrayList<Board> hotList = new ArrayList<Board>();
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			ResultSet rs = pstmt.executeQuery();
			
			while (rs.next()) 
			{
				Board board = new Board();
				board.setNo(rs.getInt("no"));
				board.setTitle(rs.getString("title"));
				board.setAddr(rs.getString("addr"));
				board.setType(rs.getString("type"));
				board.setPrice(rs.getString("price"));
				board.setContent(rs.getString("content"));
				board.setWriter(rs.getString("writer"));
				board.setWriteDate(rs.getString("writeDate"));
				board.setViewCount(rs.getInt("viewCount"));
				hotList.add(board);
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return hotList;
	}
}
