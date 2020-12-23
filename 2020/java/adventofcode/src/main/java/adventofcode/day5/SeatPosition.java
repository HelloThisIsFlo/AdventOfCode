package adventofcode.day5;

import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;
import org.apache.commons.lang3.builder.ToStringBuilder;

public class SeatPosition {
  public final int row;
  public final int column;

  public SeatPosition(int row, int column) {
    this.row = row;
    this.column = column;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }

    if (o == null || getClass() != o.getClass()) {
      return false;
    }

    SeatPosition that = (SeatPosition) o;

    return new EqualsBuilder()
        .append(row, that.row)
        .append(column, that.column)
        .isEquals();
  }

  @Override
  public int hashCode() {
    return new HashCodeBuilder(17, 37)
        .append(row)
        .append(column)
        .toHashCode();
  }

  @Override
  public String toString() {
    return new ToStringBuilder(this)
        .append("row", row)
        .append("column", column)
        .toString();
  }
}
