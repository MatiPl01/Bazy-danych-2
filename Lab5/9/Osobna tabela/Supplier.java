package com.matipl01;

import javax.persistence.*;

@Entity
@SecondaryTable(name = "Address")
public class Supplier {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "Supplier_GEN")
    @SequenceGenerator(name = "Supplier_GEN", sequenceName = "Supplier_SEQ")
    public int supplierID;

    private String companyName;

    @Column(table = "Address")
    private String city;
    @Column(table = "Address")
    private String street;

    public Supplier() {}

    public Supplier(String companyName, String city, String street) {
        this.companyName = companyName;
        this.city = city;
        this.street = street;
        this.street = street;
    }

    @Override
    public String toString() {
        return companyName;
    }

    public String getCity() {
        return city;
    }

    public String getStreet() {
        return street;
    }
}
