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

        // Create Suppliers
        Supplier supplier1 = new Supplier("Owocowy Raj", "Kraków", "Miodowa");
        Supplier supplier2 = new Supplier("Elektro", "Warszawa", "Długa");

        // Save suppliers
        etx.begin();
        em.persist(supplier1);
        em.persist(supplier2);
        etx.commit();
        em.close();
    }
}