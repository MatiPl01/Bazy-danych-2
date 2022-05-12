package com.matipl01;

import javax.persistence.Entity;

@Entity
public class Customer extends Company {
    private double discount; // %

    public Customer() {}

    public Customer(String companyName, String street, String city, String zipCode, double discount) {
        super(companyName, street, city, zipCode);
        this.discount = discount;
    }
}
