package com.matipl01;

import javax.persistence.*;

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
        EntityManager em = getEntityManager();
        EntityTransaction etx = em.getTransaction();

        // Create products
        Product product1 = new Product("Smartfon", 25);
        Product product2 = new Product("Tablet", 45);
        Product product3 = new Product("Konsola", 11);
        Product product4 = new Product("Smartwatch", 32);

        // Create invoices
        Invoice invoice1 = new Invoice();
        Invoice invoice2 = new Invoice();

        // Add products to invoices
        etx.begin();
        invoice1.addProduct(product1, 5);
        invoice2.addProduct(product3, 7);
        invoice1.addProduct(product2, 8);
        invoice1.addProduct(product3, 7);
        em.persist(invoice1);
        em.persist(invoice2);
        etx.commit();

        // Add invoices to products
        etx.begin();
        product1.sell(invoice1, 11);
        product2.sell(invoice2, 12);
        product3.sell(invoice2, 3);
        product4.sell(invoice1, 7);
        em.persist(product1);
        em.persist(product2);
        em.persist(product3);
        em.persist(product4);
        etx.commit();
        em.close();
    }
}
