package com.matipl01;

import javax.persistence.*;
import java.util.Collection;
import java.util.HashSet;

@Entity
public class Invoice {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "Invoice_GEN")
    @SequenceGenerator(name = "Invoice_GEN", sequenceName = "Invoice_SEQ")
    private int invoiceNumber;

    private int quantity = 0;

    @ManyToMany(cascade = CascadeType.PERSIST)
    private Collection<Product> products = new HashSet<>();

    public Invoice() {}

    @Override
    public String toString() {
        return String.valueOf(invoiceNumber);
    }

    public void addProduct(Product product, int quantity) {
        this.products.add(product);
        this.quantity += quantity;
    }

    public int getInvoiceNumber() {
        return invoiceNumber;
    }

    public int getQuantity() {
        return quantity;
    }

    public Collection<Product> getProducts() {
        return products;
    }
}
