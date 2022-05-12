package com.matipl01;

import javax.management.InvalidAttributeValueException;
import javax.persistence.*;
import java.util.Collection;
import java.util.HashSet;

@Entity
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int productID;

    private String productName;
    private int unitsInStock;

    @ManyToMany(mappedBy = "products")
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

    public int getUnitsInStock() {
        return unitsInStock;
    }

    public Collection<Invoice> getInvoices() {
        return invoices;
    }

    public void sell(Invoice invoice, int quantity) throws InvalidAttributeValueException {
        if (unitsInStock < quantity) {
            throw new InvalidAttributeValueException("Unable to sell " + quantity + " products");
        }
        unitsInStock -= quantity;
        invoice.addProduct(this, quantity);
        invoices.add(invoice);
    }
}
