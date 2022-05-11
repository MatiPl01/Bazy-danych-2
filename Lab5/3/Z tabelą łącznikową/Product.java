package com.matipl01;

import javax.persistence.*;

@Table(name = "Products")
@Entity
@SequenceGenerator(name = "Product_SEQ")
public class Product {
    @Id
    @GeneratedValue(strategy=GenerationType.SEQUENCE, generator = "Product_SEQ")
    private int productID;

    private String productName;
    private int unitsInStock;

    public Product() {}

    public Product(String productName, int unitsInStock) {
        this.productName = productName;
        this.unitsInStock = unitsInStock;
    }

    @Override
    public String toString() {
        return productName + " (" + unitsInStock + " szt.)";
    }
}
