namespace MateuszLopacinskiEFProducts
{
  internal class Product
  {
    public int ProductID { get; set; }

    public string ProductName { get; set; }
    public int UnitsInStock { get; set; }

    // Navigation properties
    public virtual ICollection<InvoiceItem> InvoiceItems { get; set; }

    public override string ToString()
    {
      return $"{ProductName} ({UnitsInStock} szt. dostępnych)";
    }
  }
}
