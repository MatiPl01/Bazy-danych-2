package com.matipl01;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
import org.hibernate.query.Query;

import javax.management.InvalidAttributeValueException;
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

    public static void main(final String[] args) throws InvalidAttributeValueException {
        Query query;

        try (Session session = getSession()) {
            Transaction tx = session.beginTransaction();

            // Create new products and assign a category to them
            Category electronics = new Category("elektronika");
            Product smartphone = new Product("Smartfon", electronics, 321);
            Product tablet = new Product("Tablet", electronics, 123);
            electronics.addProduct(smartphone);
            electronics.addProduct(tablet);

            // Sell existing products
            Invoice invoice1 = new Invoice();
            int soldCount = 55;
            query = session.createQuery("from Product where unitsInStock >" + soldCount);
            List<Product> products = query.getResultList();

            products.forEach(p -> {
                try {
                    p.sell(invoice1, soldCount);
                } catch (InvalidAttributeValueException e) {
                    e.printStackTrace();
                }
            });

            // Sell new products
            smartphone.sell(invoice1, 3);

            Invoice invoice2 = new Invoice();
            smartphone.sell(invoice2, 2);
            smartphone.sell(invoice2, 1);

            session.save(invoice1);
            session.save(invoice2);
            session.save(electronics);
            session.save(smartphone);
            session.save(tablet);

            tx.commit();

            // Tests
            // Get the list of products sold in the specific invoice (I'm checking all invoices)
            query = session.createQuery("from Invoice");
            query.getResultList().forEach(i -> {
                Invoice invoice = ((Invoice) i);
                List<Product> products_ = (List<Product>) invoice.getProducts();
                System.out.println("\nFaktura numer: " + i + ": ");
                System.out.println("\tŁączna liczba produktów: " + invoice.getQuantity());
                products_.forEach(p -> System.out.println("\t- " + p.getName() + ","));
                if (products_.size() == 0) System.out.println("\tBrak");
            });

            // Get all invoices for a product
            query = session.createQuery("from Product");
            query.getResultList().forEach(p -> {
                Product product = ((Product) p);
                List<Invoice> invoices = (List<Invoice>) product.getInvoices();
                System.out.println("\nFaktury, na których występuje produkt: " + product.getName() + ": ");
                invoices.forEach(i -> System.out.println("\t- " + i + ","));
                if (invoices.size() == 0) System.out.println("\tBrak");
            });
        }
    }
}
