package restaurant;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;

//�����ͺ��̽��� 1:1 ����
public class RestaurantDAO { // Database Access Object ������ ���� ��ü
	Connection conn;
	int no;

	public RestaurantDAO() // MySQL �����ϴ� �κ�
	{
		try 
		{
			String driver = "com.mysql.jdbc.Driver";
			String dbURL = "jdbc:mysql://localhost:3306/board"; // board��� ������ ���̽�
			String dbID = "root";
			String dbPassword = "root";
			
			// 1. ����̹� Ȯ��
			Class.forName(driver);
			// 2. ����
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
			PreparedStatement pstmt = this.conn.prepareStatement(SQL); // conn ��ü�� �̿��ؼ� SQL������ �����غ�ܰ�� ����
			pstmt.setInt(1, this.no = getNext());
			pstmt.setString(2, title); // ������ �̸�
			pstmt.setString(3, addr); // ������ �ּ�
			pstmt.setString(4, phoneNumber); // ������ ��ȭ��ȣ
			pstmt.setString(5, type); // ������ �з�
			pstmt.setString(6, price); // ������ ���ݴ�
			pstmt.setString(7, businessTime); // ������ �����ð�
			pstmt.setString(8, breakTime); // ������ �޽Ľð�
			pstmt.setString(9, getDate()); // �ֱ� ������Ʈ �ð�
			pstmt.setString(10, getDate());
			pstmt.setInt(11, 0);
			
			return pstmt.executeUpdate(); // ���������� insert, update, delete �� 0�̻��� ����� ��ȯ��
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return -1; //�����ͺ��̽� ����
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
			return -1; //�����ͺ��̽� ����
		}
	}
	
	public String getDate() 
	{
		//������ �ð��� �������� mysql ����
		String SQL = "select now()";
		
		try 
		{
			// pstmt ���� ��ü / conn ��ü�� �̿��ؼ� SQL������ �����غ�ܰ�� ����
			PreparedStatement pstmt = this.conn.prepareStatement(SQL);
			ResultSet rs = pstmt.executeQuery(); // ������ ������������ ���
			
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
		// ���������� �ؼ� ���� �������� ���� �� ��ȣ�� ������ ��
		String SQL = "select no from restaurant order by no desc";
		
		try 
		{
			PreparedStatement pstmt = this.conn.prepareStatement(SQL); // conn ��ü�� �̿��ؼ� SQL������ �����غ�ܰ�� ����
			ResultSet rs = pstmt.executeQuery(); // ������ ������������ ���
			
			if (rs.next())
			{
				return rs.getInt(1) + 1; // �������� �� �� �� �Խñ� ��ȣ ������ �� + 1				
			}
			
			return 1; // �Խù��� ���� ���(ù �Խù�)
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return -1; // �����ͺ��̽� ����
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
		return null; // �ش� ��ȣ�� �������� �������� ���� ��
	}
	
	public ArrayList<Restaurant> getNewRest() 
	{
		String SQL = "select * from restaurant order by registerTime desc limit 6"; // 6���� �������� ��������
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
		String SQL = "select * from restaurant order by viewCount desc limit 6"; // 6���� �������� ��������
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
		Collections.reverse(restImgList); // ����Ʈ ���� ������
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
				result = 1; // ���ƿ� ������ ��
			}
			else
			{
				result = 0; // ���ƿ� �� ������ ��
			}
			
			return result;
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			return result; // ����
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
			return -1; // ����
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
			return -1; // ����
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
			return -1; // ����
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
			pstmt.setString(1, title); // ������ �̸�
			pstmt.setString(2, addr); // ������ �ּ�
			pstmt.setString(3, phoneNumber); // ������ ��ȭ��ȣ
			pstmt.setString(4, type); // ������ �з�
			pstmt.setString(5, price); // ������ ���ݴ�
			pstmt.setString(6, businessTime); // ������ �����ð�
			pstmt.setString(7, breakTime); // ������ �޽Ľð�
			pstmt.setString(8, getDate()); // �ֱ� ������Ʈ �ð�
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
