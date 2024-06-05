package restaurant;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;

//데이터베이스와 1:1 연동
public class RestaurantDAO { // Database Access Object 데이터 접근 객체
	Connection conn;
	int no;

	public RestaurantDAO() // MySQL 접속하는 부분
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
	
	public int restaurantWrite(String title, String addr, String phoneNumber, String type, 
								String price, String businessTime, String breakTime) 
	{
		String SQL = "insert into restaurant values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL); // conn 객체를 이용해서 SQL문장을 실행준비단계로 만듬
			pstmt.setInt(1, this.no = getNext());
			pstmt.setString(2, title); // 음식점 이름
			pstmt.setString(3, addr); // 음식점 주소
			pstmt.setString(4, phoneNumber); // 음식점 전화번호
			pstmt.setString(5, type); // 음식점 분류
			pstmt.setString(6, price); // 음식점 가격대
			pstmt.setString(7, businessTime); // 음식점 영업시간
			pstmt.setString(8, breakTime); // 음식점 휴식시간
			pstmt.setString(9, getDate()); // 최근 업데이트 시간
			pstmt.setString(10, getDate());
			pstmt.setInt(11, 0);
			
			return pstmt.executeUpdate(); // 성공적으로 insert, update, delete 시 0이상의 결과를 반환함
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return -1; //데이터베이스 오류
		}
	}
	
	public int restaurantWriteImg(int no, String fileRealName, int imgNo) 
	{
		String SQL = "insert into restaurantimg values (?, ?, ?)";
		
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
		String SQL = "select no from restaurant order by no desc";
		
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
	
	public Restaurant getRestaurant(int no) 
	{
		String SQL = "select * from restaurant where no = ?";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setInt(1, no);
			ResultSet rs = pstmt.executeQuery();
			
			if (rs.next()) 
			{
				Restaurant rest = new Restaurant();
				rest.setNo(rs.getInt(1));
				rest.setTitle(rs.getString(2));
				rest.setAddr(rs.getString(3));
				rest.setPhoneNumber(rs.getString(4));
				rest.setType(rs.getString(5));
				rest.setPrice(rs.getString(6));
				rest.setBusinessTime(rs.getString(7));
				rest.setBreakTime(rs.getString(8));
				rest.setUpdateTime(rs.getString(9));
				rest.setViewCount(rs.getInt("viewCount"));
				
				return rest;
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return null; // 해당 번호의 음식점이 존재하지 않을 때
	}
	
	public ArrayList<Restaurant> getNewRest() 
	{
		String SQL = "select * from restaurant order by registerTime desc limit 6"; // 6개의 음식점만 가져오기
		ArrayList<Restaurant> list = new ArrayList<>();
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			ResultSet rs = pstmt.executeQuery();
			
			while (rs.next()) 
			{
				Restaurant rest = new Restaurant();
				rest.setNo(rs.getInt(1));
				rest.setTitle(rs.getString(2));
				rest.setAddr(rs.getString(3));
				rest.setPhoneNumber(rs.getString(4));
				rest.setType(rs.getString(5));
				rest.setPrice(rs.getString(6));
				rest.setBusinessTime(rs.getString(7));
				rest.setBreakTime(rs.getString(8));
				rest.setUpdateTime(rs.getString(9));
				rest.setViewCount(rs.getInt("viewCount"));
				
				list.add(rest);
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return list;
	}
	
	public ArrayList<Restaurant> getHotRest() 
	{
		String SQL = "select * from restaurant order by viewCount desc limit 6"; // 6개의 음식점만 가져오기
		ArrayList<Restaurant> list = new ArrayList<>();
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			ResultSet rs = pstmt.executeQuery();
			
			while (rs.next()) 
			{
				Restaurant rest = new Restaurant();
				rest.setNo(rs.getInt(1));
				rest.setTitle(rs.getString(2));
				rest.setAddr(rs.getString(3));
				rest.setPhoneNumber(rs.getString(4));
				rest.setType(rs.getString(5));
				rest.setPrice(rs.getString(6));
				rest.setBusinessTime(rs.getString(7));
				rest.setBreakTime(rs.getString(8));
				rest.setUpdateTime(rs.getString(9));
				rest.setViewCount(rs.getInt("viewCount"));
				
				list.add(rest);
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return list;
	}
	
	public ArrayList<String> getRestaurantImg(int no) 
	{
		String SQL = "select * from restaurantimg where no = ?";
		ArrayList<String> restImgList = new ArrayList<>();
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setInt(1, no);
			ResultSet rs = pstmt.executeQuery();
			
			while (rs.next())
			{
				restImgList.add(rs.getString(2));
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		Collections.reverse(restImgList); // 리스트 순서 뒤집기
		return restImgList;
	}
	
	public int getNo() 
	{
		return this.no;
	}
	
	public int isLike(int no, String userID)
	{
		String SQL = "select * from restaurantlike where no = ? and userID = ?";
		int result = -1;
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setInt(1, no);
			pstmt.setString(2, userID);
			ResultSet rs = pstmt.executeQuery();
			
			if (rs.next())
			{
				result = 1; // 좋아요 눌렀을 시
			}
			else
			{
				result = 0; // 좋아요 안 눌렀을 시
			}
			
			return result;
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return result; // 에러
		}
	}
	
	public int addLike(int no, String userID)
	{
		String SQL = "insert into restaurantlike values (?, ?)";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setInt(1, no);
			pstmt.setString(2, userID);
			
			return pstmt.executeUpdate();		
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return -1; // 에러
		}
	}
	
	public int deleteLike(int no, String userID)
	{
		String SQL = "delete from restaurantlike where no = ? and userID = ?";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setInt(1, no);
			pstmt.setString(2, userID);
			
			return pstmt.executeUpdate();		
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return -1; // 에러
		}
	}
	
	public int getLikeCount(int no)
	{
		String SQL = "select * from restaurantlike where no = ?";
		int cnt = 0;
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setInt(1, no);			
			ResultSet rs = pstmt.executeQuery();
			
			while (rs.next())
			{
				cnt++;
			}
			
			return cnt;
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return -1; // 에러
		}
	}
	
	public ArrayList<Restaurant> searchRestaurant(String search)
	{
		String SQL = "select * from restaurant where concat(title, addr, type) like ?";
		ArrayList<Restaurant> searchList = new ArrayList<Restaurant>();
		
		try 
		{			
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setString(1, "%" + search + "%");
			ResultSet rs = pstmt.executeQuery();
			
			while (rs.next())
			{
				searchList.add(getRestaurant(rs.getInt("no")));
			}
			
			return searchList;
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return null;
		}
	}
	
	public int upViewCount(int no, int viewCount)
	{
		String SQL = "update restaurant set viewCount = ? where no = ?";
		
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

	public int restaurantUpdate(int no, String title, String addr, String phoneNumber, String type, 
									String price, String businessTime, String breakTime) 
	{
		String SQL = "update restaurant set title = ?, addr = ?, phoneNumber = ?, type = ?, price = ?, businessTime = ?, breakTime = ?, updateTime = ? where no = ?";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			pstmt.setString(1, title); // 음식점 이름
			pstmt.setString(2, addr); // 음식점 주소
			pstmt.setString(3, phoneNumber); // 음식점 전화번호
			pstmt.setString(4, type); // 음식점 분류
			pstmt.setString(5, price); // 음식점 가격대
			pstmt.setString(6, businessTime); // 음식점 영업시간
			pstmt.setString(7, breakTime); // 음식점 휴식시간
			pstmt.setString(8, getDate()); // 최근 업데이트 시간
			pstmt.setInt(9, no);
			
			return pstmt.executeUpdate();
		}
		catch (Exception e) 
		{
			e.printStackTrace();
			return -1;
		}
	}
	
	public int restaurantImgUpdate(int no, String fileRealName, int imgNo) 
	{
		String SQL = "update restaurantImg set fileRealName = ? where no = ? and imgNo = ?";
		
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
	
	public void serverImgFileRemove(String preFileRealName, String restaurantImgPath)
	{
		if (preFileRealName == null)
		{
			return;
		}
		
		File file = new File(restaurantImgPath + preFileRealName);
		file.delete();
	}
	
	public int delete(int no) 
	{
		String SQL = "delete from restaurant where no = ?";
		
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
		String SQL = "delete from restaurantimg where no = ?";
		
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
	
	public int deleteRestLike(int no)
	{
		String SQL = "delete from restaurantlike where no = ?";
		
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
}
