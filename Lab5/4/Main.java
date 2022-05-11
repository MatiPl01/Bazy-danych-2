package com.matipl01;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
import org.hibernate.query.Query;

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

            Product product1 = new Product("Krzesło", 111);
            Product product2 = new Product("Stół", 23);
            Product product3 = new Product("Szafa", 44);
            Product product4 = new Product("Komoda", 53);

            Supplier supplier1 = new Supplier("Dostawca 1", "Malinowa", "Poznań");
            Supplier supplier2 = new Supplier("Dostawca 2", "Konwaliowa", "Kraków");

            supplier1.addProducts(product1, product3, product4);
            product1.setSupplier(supplier1);
            product3.setSupplier(supplier1);
            product4.setSupplier(supplier1);

            supplier2.addProducts(product2);
            product2.setSupplier(supplier2);

            session.save(product1);
            session.save(product2);
            session.save(product3);
            session.save(product4);
            session.save(supplier1);
            session.save(supplier2);
            tx.commit();

            // Testowanie
            Query query = session.createQuery("from Supplier");
            query.getResultList().forEach(s -> {
                ((Supplier) s).getProducts().forEach(p -> System.out.println(s + " dostarcza " + p));
            });

            query = session.createQuery("from Product");
            query.getResultList().forEach(p -> {
                System.out.println(p + " jest dostarczany/e/a przez " + ((Product) p).getSupplier());
            });
        }
    }
}
