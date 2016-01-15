package com.order.student.common;

import java.sql.SQLException;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

public class CoaHibernateDaoSupport extends HibernateDaoSupport {
	/**
	 * ʹ��hql�����з�ҳ��ѯ
	 * @param hql ��Ҫ��ѯ��hql���
	 * @param offset ��һ����¼����
	 * @param pageSize ÿҳ��Ҫ��ʾ�ļ�¼��
	 * @return ��ǰҳ�����м�¼
	 */
	@SuppressWarnings("unchecked")
	public List findByPage(final String hql, 
		final int offset, final int pageSize)
	{
		//ͨ��һ��HibernateCallback������ִ�в�ѯ
		List list = getHibernateTemplate()
			.executeFind(new HibernateCallback()
		{
			//ʵ��HibernateCallback�ӿڱ���ʵ�ֵķ���
			public Object doInHibernate(Session session)
				throws HibernateException, SQLException
			{
				//ִ��Hibernate��ҳ��ѯ
				List result = session.createQuery(hql)
					.setFirstResult(offset)
					.setMaxResults(pageSize)
					.list();
				return result;
			}
		});
		return list;
	}

	@SuppressWarnings("unchecked")
	public List findByPage3(final String hql , final Object value1 ,final Object value2 ,
		final int offset, final int pageSize)
	{
		//ͨ��һ��HibernateCallback������ִ�в�ѯ
		List list = getHibernateTemplate()
			.executeFind(new HibernateCallback()
		{
			//ʵ��HibernateCallback�ӿڱ���ʵ�ֵķ���
			public Object doInHibernate(Session session)
				throws HibernateException, SQLException
			{
				//ִ��Hibernate��ҳ��ѯ
				List result = session.createQuery(hql)
					//Ϊhql��䴫�����
					.setParameter(0, value1).setParameter(1, value2)
					.setFirstResult(offset)
					.setMaxResults(pageSize)
					.list();
				return result;
			}
		});
		return list;
	}

	
	
	
	/**
	 * ʹ��hql�����з�ҳ��ѯ
	 * @param hql ��Ҫ��ѯ��hql���
	 * @param value ���hql��һ��������Ҫ���룬value���Ǵ���hql���Ĳ���
	 * @param offset ��һ����¼����
	 * @param pageSize ÿҳ��Ҫ��ʾ�ļ�¼��
	 * @return ��ǰҳ�����м�¼
	 */
	@SuppressWarnings("unchecked")
	public List findByPage1(final String hql , final Object value ,
		final int offset, final int pageSize)
	{
		//ͨ��һ��HibernateCallback������ִ�в�ѯ
		List list = getHibernateTemplate()
			.executeFind(new HibernateCallback()
		{
			//ʵ��HibernateCallback�ӿڱ���ʵ�ֵķ���
			public Object doInHibernate(Session session)
				throws HibernateException, SQLException
			{
				//ִ��Hibernate��ҳ��ѯ
				List result = session.createQuery(hql)
					//Ϊhql��䴫�����
					.setParameter(0, value) 
					.setFirstResult(offset)
					.setMaxResults(pageSize)
					.list();
				return result;
			}
		});
		return list;
	}

	/**
	 * ʹ��hql�����з�ҳ��ѯ
	 * @param hql ��Ҫ��ѯ��hql���
	 * @param values ���hql�ж����������Ҫ���룬values���Ǵ���hql�Ĳ�������
	 * @param offset ��һ����¼����
	 * @param pageSize ÿҳ��Ҫ��ʾ�ļ�¼��
	 * @return ��ǰҳ�����м�¼
	 */
	@SuppressWarnings("unchecked")
	public List findByPage2(final String hql, final Object[] values,
		final int offset, final int pageSize)
	{
		//ͨ��һ��HibernateCallback������ִ�в�ѯ
		List list = getHibernateTemplate()
			.executeFind(new HibernateCallback()
		{
			//ʵ��HibernateCallback�ӿڱ���ʵ�ֵķ���
			public Object doInHibernate(Session session)
				throws HibernateException, SQLException
			{
				//ִ��Hibernate��ҳ��ѯ
				Query query = session.createQuery(hql);
				//Ϊhql��䴫�����
				for (int i = 0 ; i < values.length ; i++)
				{
					query.setParameter( i, values[i]);
				}
				List result = query.setFirstResult(offset)
					.setMaxResults(pageSize)
					.list();
				return result;
			}
		});
		return list;
	}
//	
//	public int[] pageNumber(int postAmount,String pageNumberStr,int pageSize){
//		int[] paging = new int[2];
//		int pageNumber = 1;
//		pageNumber = Integer.parseInt(pageNumberStr);
//		if(pageNumber <= 0){
//			pageNumber = 1;
//		}
//		int totalPage = 1;
//		if(postAmount > 0){
//			totalPage = postAmount%pageSize==0?(postAmount/pageSize):(postAmount/pageSize+1);
//		}
//		if(pageNumber > totalPage){
//			pageNumber = totalPage;
//		}
//		paging[0] = pageNumber;
//		paging[1] = totalPage;
//		return paging;
//	}

}
