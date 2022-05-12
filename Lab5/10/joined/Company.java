package com.matipl01;

import javax.persistence.*;

@Entity
@Inheritance(strategy = InheritanceType.JOINED)
public abstract class Company {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "Company_GEN")
    @SequenceGenerator(name = "Company_GEN", sequenceName = "Company_SEQ")
    private int companyID;

    private String companyName;
    private String street;
    private String city;
    private String zipCode;

    public Company() {}

    public Company(String companyName, String street, String city, String zipCode) {
        this.companyName = companyName;
        this.zipCode = zipCode;
        this.street = street;
        this.city = city;
    }

    @Override
    public String toString() {
        return companyName;
    }

    public String getCompanyName() {
        return companyName;
    }

    public String getStreet() {
        return street;
    }

    public String getCity() {
        return city;
    }

    public String getZipCode() {
        return zipCode;
    }
}
