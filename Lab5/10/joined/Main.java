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

        // Save suppliers
        etx.begin();

        Customer customer1 = new Customer("Klient 1", "Hofmana Vlastimila", "Kraków", "30‑210", 5.5);
        Customer customer2 = new Customer("Klient 2", "3 Maja Al.", "Kraków", "30‑063", 9.75);

        Supplier supplier1 = new Supplier("Dostawca 1", "Mikołaja Kopernika 3", "Warszawa", "00-367", "123123123123123123123123");
        Supplier supplier2 = new Supplier("Dostawca 2", "Oboźna", "Kraków", "30-011", "999888777666555444333222");

        em.persist(customer1);
        em.persist(customer2);
        em.persist(supplier1);
        em.persist(supplier2);

        etx.commit();
        em.close();
    }
}
