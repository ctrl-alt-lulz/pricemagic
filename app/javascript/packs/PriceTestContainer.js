import React from 'react'
import ReactDOM from 'react-dom'
import ReactTable from 'react-table'
import PropTypes from 'prop-types'

import { Page, Card, Select, Button, TextField, Stack, FormLayout,
Thumbnail, ResourceList, Pagination, Layout, Checkbox } from '@shopify/polaris';

export default class PriceTestContainer extends React.Component {
  constructor(props) {
    super(props);
  }
  render() {
    const price_points = this.props.price_points
    const price_multipler = this.props.price_multipler
    const end_digits = this.props.end_digits
    const product = this.props.product
    
    function CreateItem(variant) {
      return { 
        variant_title: variant.variant_title,
        variant_price: variant.variant_price
      }
    }
    function CreateColumns() {
        return {
                columns: SeedColumnData(price_points)
               }
    }
    function SeedColumnData(price_points) {
      var columns = [];
      for (price_points > 0; price_points--;) {
        columns.unshift(
          { Header: 'Price Test #' + price_points,
            accessor: 'test_price_' + price_points
          });
      } 
      return columns
    }
    // TODO Clean Up Names
    function CalcPricePointData(base) {
      var pp = price_points
      for (pp > 0; pp--;) {
        $.extend(base, {[ 'test_price_' + pp]: RoundPriceDigits(base.variant_price * price_multipler[pp])})
      }
      return base
    }
    function RoundPriceDigits(price) {
      return Math.floor(price) + end_digits
    }
    const data = this.props.product.variants.map(CreateItem).map(CalcPricePointData)

    return (<ReactTable
              data={data}
              columns={[
              {
                Header: "Base",
                columns: [
                  {
                    Header: "Product Title",
                    accessor: "variant_title"
                  },{
                    Header: "Price",
                    accessor: "variant_price"
                  }
                ]
              },CreateColumns()
            ]}
            defaultPageSize={10}
            className="-striped -highlight"
            />
    );
  }
}
