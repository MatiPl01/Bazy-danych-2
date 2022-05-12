package com.matipl01;

import javax.persistence.*;

@Entity
public class Supplier {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "Supplier_GEN")
    @SequenceGenerator(name = "Supplier_GEN", sequenceName = "Supplier_SEQ")
    public int supplierID;

    private String companyName;

    @Embedded
    private Address address;

    public Supplier() {}

    public Supplier(String companyName, Address address) {
        this.companyName = companyName;
        this.address = address;
    }

    @Override
    public String toString() {
        return companyName;
    }

    public void setAddress(Address address) {
        this.address = address;
    }

    public Address getAddress() {
        return address;
    }
}
