namespace MateuszLopacinskiEFProducts
{
  internal class Customer : Company
  {
    public int CustomerID { get; set; }
    public int Discount { get; set; } // In %

    public override string ToString()
    {
      return $"{base.ToString()} (klient)";
    }
  }
}
