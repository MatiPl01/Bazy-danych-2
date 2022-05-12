package com.matipl01;

import javax.persistence.*;
import java.util.Collection;
import java.util.HashSet;

@Entity
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "Product_GEN")
    @SequenceGenerator(name = "Product_GEN", sequenceName = "Product_SEQ")
    private int productID;

    private String productName;
    private int unitsInStock;

    @ManyToMany(
            cascade = CascadeType.PERSIST,
            fetch = FetchType.EAGER,
            mappedBy = "products"
    )
    private final Collection<Invoice> invoices = new HashSet<>();

    public Product() {}

    public Product(String productName, int unitsInStock) {
        this.productName = productName;
        this.unitsInStock = unitsInStock;
    }

    @Override
    public String toString() {
        return productName + " (" + unitsInStock + " szt.)";
    }

    public String getName() {
        return productName;
    }

    public Collection<Invoice> getInvoices() {
        return invoices;
    }

    public int getUnitsInStock() {
        return unitsInStock;
    }

    public void sell(Invoice invoice, int quantity) throws IllegalArgumentException {
        if (unitsInStock < quantity) {
            throw new IllegalArgumentException("Unable to sell " + quantity + " products");
        }
        invoices.add(invoice);
        invoice.updateQuantity(quantity);
    }
}
