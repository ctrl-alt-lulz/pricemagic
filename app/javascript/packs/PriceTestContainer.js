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
        columns.unshift({Header: 'Price Test #' + price_points});
      } 
      return columns
    }
    const data = this.props.price_test.variants.map(CreateItem)
    console.log(this.props.price_test)
    console.log(this.props.price_test.variants)
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