package com.matipl01;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
import org.hibernate.query.Query;

import java.util.List;

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
        Query query;

        try (Session session = getSession()) {
            Transaction tx = session.beginTransaction();
            Category furniture = new Category("meble");
            Category food = new Category("food");

            // Assign category to the existing products
            query = session.createQuery("from Product");
            List<Product> products = query.getResultList();
            products.forEach(furniture::addProduct);
            products.forEach(p -> p.setCategory(furniture));

            // Create new products and assign a category to them
            Product apple = new Product("Jabłko", food, 59);
            Product bread = new Product("Chleb", food, 232);
            food.addProduct(apple);
            food.addProduct(bread);

            session.save(furniture);
            session.save(food);
            session.save(apple);
            session.save(bread);

            // Tests
                // Produkty należące do kategorii
            query = session.createQuery("from Category");
            query.getResultList().forEach(c -> {
                System.out.println("Kategoria: " + c + ": ");
                ((Category) c).getProducts().forEach(p -> System.out.println("\t- " + p + ","));
            });
            tx.commit();

                // Kategoria, do której należy produkt
            System.out.println(apple + " należy do kategorii: " + apple.getCategory());

            if (products.size() >= 2) {
                Product product = products.get(1);
                System.out.println(product + " należy do kategorii: " + product.getCategory());
            }
        }
    }
}
