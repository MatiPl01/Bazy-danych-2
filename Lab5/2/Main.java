package com.matipl01;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

public class Main {
    private static final SessionFactory ourSessionFactory;

    static {
        try {
            Configuration configuration = new Configuration();
            configuration.configure();

            ourSessionFactory = configuration.buildSessionFactory();
        } catch (Throwable ex) {
            throw new ExceptionInInitializerError(ex);
        }
    }

    public static Session getSession() throws HibernateException {
        return ourSessionFactory.openSession();
    }

    public static void main(final String[] args) {
        try (Session session = getSession()) {
            Transaction tx = session.beginTransaction();

            // Create the new supplier
            Supplier supplier = new Supplier("Super dostawca", "Malinowa", "Poznań");

            // Get the previously added product
            Product product = session.get(Product.class, 1);
            product.setSupplier(supplier);
            session.save(supplier);
            tx.commit();

            // Testowanie
            Query query = session.createQuery("from Product");
            query.getResultList().forEach(p -> {
                System.out.println("Produkt '" + p + "' jest dostarczany przez '" + ((Product) p).getSupplier() + "'");
            });
        }
    }
}
