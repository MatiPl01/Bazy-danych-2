namespace MateuszLopacinskiEFProducts
{
  internal class Product
  {
    public int ProductID { get; set; }
    public string ProductName { get; set; }
    public int UnitsOnStock { get; set; }

    public override string ToString()
    {
      return $"{ProductName} ({UnitsOnStock} szt.)";
    }
  }
}
