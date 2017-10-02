import React from 'react'
import ReactDOM from 'react-dom'
import ReactTable from 'react-table'
import PropTypes from 'prop-types'
import { Checkbox } from '@shopify/polaris';

export default class ProductIndexTable extends React.Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this)
  }
  handleChange(event) {
    // const target = event.target;
    // const value = target.value;
    // console.log(event)
    // console.log(value)
    console.log('test')
  }
  render() {
    function CreateItem(product) {
      return { 
        title: <a href={'/products/' + product.id} >{product.title}</a>,
        price_test_status: product.has_active_price_test,
        price_test_completion_percentage: product.price_test_completion_percentage,
      }
    }
  return (<ReactTable
            data={this.props.products.map(CreateItem)}
            getTdProps={(state, rowInfo, column, instance) => {
              return {
                onClick: (e, handleOriginal) => {
                  console.log('A Td Element was clicked!')
                  console.log('it produced this event:', e)
                  console.log('It was in this column:', column)
                  console.log('It was in this row:', rowInfo)
                  console.log('It was in this table instance:', instance)
                  
                  // IMPORTANT! React-Table uses onClick internally to trigger
                  // events like expanding SubComponents and pivots.
                  // By default a custom 'onClick' handler will override this functionality.
                  // If you want to fire the original onClick handler, call the
                  // 'handleOriginal' function.
                  if (handleOriginal) {
                    handleOriginal()
                  }
                }
              }
            }}
            columns={[
            {
              Header: "Base",
              columns: [
                {
                  Header: <Checkbox />,
                  maxWidth: 50,
                  Cell: row => (<Checkbox onChange={this.handleChange} />)
                }, {
                  Header: "Product Title",
                  accessor: "title",
                  maxWidth: 400
                }, {
                  Header: "Price Test Status",
                  accessor: "price_test_status",
                  maxWidth: 200
                }, {
                  Header: "Price Test Completion Percentage",
                  accessor: "price_test_completion_percentage",
                  Cell: row => (
                    <div
                      style={{
                        width: '100%',
                        height: '100%',
                        backgroundColor: '#dadada',
                        borderRadius: '2px'
                      }}
                    >
                    <div
                      style={{
                        width: `${row.value}%`,
                        height: '100%',
                        backgroundColor: row.value > 66 ? '#85cc00'
                          : row.value > 33 ? '#ffbf00'
                          : '#ff2e00',
                        borderRadius: '2px',
                        transition: 'all .2s ease-out'
                      }}
                    />
                    </div>
                  )
                }
              ]
            }
            ]}
            defaultPageSize={10}
            className="-striped -highlight"
          />
  );}
}
