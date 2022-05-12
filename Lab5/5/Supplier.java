package com.matipl01;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;

@Entity
@Table(name = "Suppliers")
public class Supplier {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "Supplier_GEN")
    @SequenceGenerator(name = "Supplier_GEN", sequenceName = "Supplier_SEQ")
    public int supplierID;

    private String companyName;
    private String street;
    private String city;

    @OneToMany(mappedBy = "supplier")
    private final Collection<Product> products = new ArrayList<>();

    public Supplier() {}

    public Supplier(String companyName, String street, String city) {
        this.companyName = companyName;
        this.street = street;
        this.city = city;
    }

    @Override
    public String toString() {
        return companyName;
    }

    public Collection<Product> getProducts() {
        return products;
    }

    public void addProducts(Product ...products) {
        this.products.addAll(Arrays.asList(products));
    }
}
