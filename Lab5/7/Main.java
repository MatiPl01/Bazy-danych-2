package com.matipl01;

import javax.management.InvalidAttributeValueException;
import javax.persistence.*;
import java.util.List;

class Main {
    private static final EntityManagerFactory emf;

    static {
        try {
            emf = Persistence.createEntityManagerFactory("derby");
        } catch (Throwable ex) {
            throw new ExceptionInInitializerError(ex);
        }
    }

    public static EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public static void main(String[] args) {
        final EntityManager em = getEntityManager();
        EntityTransaction etx = em.getTransaction();
        Query query;

        // Add products only
        etx.begin();
        Product product1 = new Product("Smartfon", 25);
        Product product2 = new Product("Tablet", 45);
        Product product3 = new Product("Konsola", 11);
        em.persist(product1);
        em.persist(product2);
        em.persist(product3);
        etx.commit();

        etx.begin();
        // Create invoices
        Invoice invoice1 = new Invoice();
        Invoice invoice2 = new Invoice();

        // Sell existing products
        int soldCount = 20;
        query = em.createQuery("from Product where unitsInStock >" + soldCount);
        List<Product> products = query.getResultList();
        products.forEach(p -> {
            if (((Product) p).getUnitsInStock() >= soldCount) {
                try {
                    ((Product) p).sell(invoice1, soldCount);
                } catch (InvalidAttributeValueException e) {
                    e.printStackTrace();
                }
            }
        });

        // Create the new products and sell them
        product1 = new Product("Mikrofalówka", 4);
        product2 = new Product("Lodówka", 14);
        product3 = new Product("Wirówka", 17);

        try {
            product1.sell(invoice2, 3);
            product2.sell(invoice1, 11);
            product2.sell(invoice2, 2);
            product3.sell(invoice2, 17);
        } catch (InvalidAttributeValueException e) {
            e.printStackTrace();
        }

        em.persist(invoice1);
        em.persist(invoice2);
        etx.commit();

        // Tests
        // Get the list of products sold in the specific invoice (I'm checking all invoices)
        query = em.createQuery("from Invoice");
        query.getResultList().forEach(i -> {
            Invoice invoice = ((Invoice) i);
            List<Product> products_ = (List<Product>) invoice.getProducts();
            System.out.println("\nFaktura numer: " + i + ": ");
            System.out.println("\tŁączna liczba produktów: " + invoice.getQuantity());
            products_.forEach(p -> System.out.println("\t- " + p.getName() + ","));
            if (products_.size() == 0) System.out.println("\tBrak");
        });

        // Get all invoices for a product
        query = em.createQuery("from Product");
        query.getResultList().forEach(p -> {
            Product product = ((Product) p);
            List<Invoice> invoices = (List<Invoice>) product.getInvoices();
            System.out.println("\nFaktury, na których występuje produkt: " + product.getName() + ": ");
            invoices.forEach(i -> System.out.println("\t- " + i + ","));
            if (invoices.size() == 0) System.out.println("\tBrak");
        });

        em.close();
    }
}
