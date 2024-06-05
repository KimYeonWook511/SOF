package review;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;

//데이터베이스와 1:1 연동
public class ReviewDAO { // Database Access Object 데이터 접근 객체
	Connection conn;
	int no;

	public ReviewDAO() // MySQL 접속하는 부분
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
		String SQL = "select no from review order by no desc";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL); // conn 객체를 이용해서 SQL문장을 실행준비단계로 만듬
			ResultSet rs = pstmt.executeQuery(); // 실제로 실행했을때의 결과
			
			if (rs.next())
			{
				return rs.getInt(1) + 1; // 내림차순 후 맨 위 게시글 번호 가져온 뒤 + 1				
			}
			
			return 1; // 게시물이 없는 경우(첫 게시물)
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return -1; // 데이터베이스 오류
		}
	}

	public int reviewWrite(int restNo, String title, String content, String writer) 
	{
		String SQL = "insert into review values (?, ?, ?, ?, ?, ?)";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL); // conn 객체를 이용해서 SQL문장을 실행준비단계로 만듬
			pstmt.setInt(1, this.no = getNext()); // getNext() 함수 호출 (게시글 번호)
			pstmt.setInt(2, restNo);
			pstmt.setString(3, title); // 파라미터(매개변수) title
			pstmt.setString(4, content); // 파라미터(매개변수) content
			pstmt.setString(5, writer); // 파라미터(매개변수) writer
			pstmt.setString(6, getDate()); // getDate() 함수 호출 (날짜)
			
			return pstmt.executeUpdate(); // 성공적으로 insert, update, delete 시 0이상의 결과를 반환함
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return -1; //데이터베이스 오류
		}
	}

	public int reviewWriteImg(int no, String fileRealName, int imgNo) 
	{
		String SQL = "insert into reviewimg values (?, ?, ?)";
		
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

	public ArrayList<Review> getReviewList(int restNo) 
	{
		String SQL = "select * from review where restNo = ? order by no desc";
		ArrayList<Review> list = new ArrayList<Review>();
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setInt(1, restNo);
			ResultSet rs = pstmt.executeQuery();
			
			while (rs.next()) 
			{
				Review review = new Review();
				review.setNo(rs.getInt("no"));
				review.setRestNo(rs.getInt("restNo"));
				review.setTitle(rs.getString("title"));
				review.setContent(rs.getString("content"));
				review.setWriter(rs.getString("writer"));
				review.setWriteDate(rs.getString("writeDate"));
				list.add(review);
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return list;
	}

	public Review getReview(int no) 
	{
		String SQL = "select * from review where no = ?";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setInt(1, no);
			ResultSet rs = pstmt.executeQuery();
			
			if (rs.next()) 
			{
				Review review = new Review();
				review.setNo(rs.getInt("no"));
				review.setRestNo(rs.getInt("restNo"));
				review.setTitle(rs.getString("title"));
				review.setContent(rs.getString("content"));
				review.setWriter(rs.getString("writer"));
				review.setWriteDate(rs.getString("writeDate"));
				
				return review;
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return null; // 해당 번호의 리뷰가 존재하지 않을 때
	}

	public ArrayList<String> getReviewImg(int no) 
	{
		String SQL = "select * from reviewimg where no = ?";
		ArrayList<String> reviewImgList = new ArrayList<>();
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setInt(1, no);
			ResultSet rs = pstmt.executeQuery();
			
			while (rs.next())
			{
				reviewImgList.add(rs.getString(2));
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		Collections.reverse(reviewImgList); // 리스트 순서 뒤집기
		return reviewImgList;
	}

	public int reviewUpdate(int no, String title, String content) 
	{
		String SQL = "update review set title = ?, content = ? where no = ?";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setString(1, title);
			pstmt.setString(2, content);
			pstmt.setInt(3, no);
			
			return pstmt.executeUpdate();
		}
		catch (Exception e) 
		{
			e.printStackTrace();
			return -1;
		}
	}

	public int reviewImgUpdate(int no, String fileRealName, int imgNo) 
	{
		String SQL = "update reviewimg set fileRealName = ? where no = ? and imgNo = ?";
		
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

	public void serverImgFileRemove(String preFileRealName, String reviewImgPath)
	{
		if (preFileRealName == null)
		{
			return;
		}
		
		File file = new File(reviewImgPath + preFileRealName);
		file.delete();
	}

	public int delete(int no) 
	{
		String SQL = "delete from review where no = ?";
		
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
		String SQL = "delete from reviewimg where no = ?";
		
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
	
	public int getNo() 
	{
		return this.no;
	}
}
