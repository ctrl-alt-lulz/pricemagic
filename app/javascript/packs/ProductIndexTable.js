import React from 'react'
import ReactDOM from 'react-dom'
import ReactTable from 'react-table'
import PropTypes from 'prop-types'

export default class ProductIndexTable extends React.Component {
  constructor(props) {
    super(props);
  }
  render() {
    function CreateItem(product) {
      return { 
        title: <a href={'/products/' + product.id} >{product.title}</a>,
        price_test_status: product.has_active_price_test 
      }
    }
  return (<ReactTable
            data={this.props.products.map(CreateItem)}
            columns={[
            {
              Header: "Base",
              columns: [
                {
                  Header: "Product Title",
                  accessor: "title"
                }, {
                  Header: "Price Test Status",
                  accessor: "price_test_status"
                }
              ]
            }
            ]}
            defaultPageSize={10}
            className="-striped -highlight"
          />
  );}
}
