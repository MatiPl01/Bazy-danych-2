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

    public void addProduct(Product product, int quantity) throws IllegalArgumentException {
        if (product.getUnitsInStock() < quantity) {
            throw new IllegalArgumentException("Unable to sell " + quantity + " products");
        }
        this.products.add(product);
        this.quantity += quantity;
    }

    public int getQuantity() {
        return quantity;
    }

    public void updateQuantity(int quantity) {
        this.quantity += quantity;
    }

    public Collection<Product> getProducts() {
        return products;
    }
}
