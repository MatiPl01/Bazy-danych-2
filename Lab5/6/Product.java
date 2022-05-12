package com.matipl01;

import javax.management.InvalidAttributeValueException;
import javax.persistence.*;
import java.util.Collection;
import java.util.HashSet;

@Entity
@Table(name = "Products")
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "Product_GEN")
    @SequenceGenerator(name = "Product_GEN", sequenceName = "Product_SEQ")
    private int productID;

    private String productName;
    private int unitsInStock;

    @ManyToOne
    @JoinColumn(name = "supplierID")
    private Supplier supplier;

    @ManyToOne
    @JoinColumn(name = "categoryID")
    private Category category;

    @ManyToMany(mappedBy = "products")
    private Collection<Invoice> invoices = new HashSet<>();

    public Product() {}

    public Product(String productName, Category category, int unitsInStock) {
        this.productName = productName;
        this.unitsInStock = unitsInStock;
        this.category = category;
    }

    @Override
    public String toString() {
        return productName + " (" + unitsInStock + " szt.)";
    }

    public String getName() {
        return productName;
    }

    public void setSupplier(Supplier supplier) {
        this.supplier = supplier;
    }

    public Supplier getSupplier() {
        return supplier;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public Category getCategory() {
        return category;
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
