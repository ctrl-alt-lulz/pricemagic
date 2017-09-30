import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import ReactTable from 'react-table'
import PriceTestForm from './PriceTestForm.js'
import PriceTestContainer from './PriceTestContainer.js'
import { BrowserRouter, Route, Link, Switch, NavLink  } from 'react-router-dom'
import { Page, Card, Select, Button, TextField, Stack, FormLayout,
        Thumbnail, ResourceList, Pagination, Layout, Checkbox, 
        FooterHelp, ActionList } from '@shopify/polaris';

class ProductIndex extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      term: '',
      collection_id: null,
      products: this.props.products,
    };
    this.handleTermChange = this.handleTermChange.bind(this);
    this.handleCollectionChange = this.handleCollectionChange.bind(this);
    this.col_hash = this.props.collections.reduce(function ( total, current ) {
        total[ current.title ] = current.id;
        return total;
    }, {});
    this.product_hash = this.props.products.reduce(function ( total, current ) {
      total[ current.title ] = current.id;
      return total;
    }, {});
  }

  handleTermChange(event) {
    this.setState({
      term: event,
      collection: null
    }, () => {
      this.searchProducts()
    });
  }
  handleCollectionChange(event) {
    this.setState({
      collection_id: this.col_hash[event],
      collection: event,
      term: ''
    }, () => {
      this.searchProducts()
    });
  }
  
  render() {
    function CreateItem(product) {
      return { 
        title: <a href={'/products/' + product.id} >{product.title}</a>, //product.title, //make a link if possible
        price_test_status: product.has_active_price_test //this.props.price_test.active
      }
    }
    function CollectionTitles(collection) {
      return collection.title
    }
    return (
      <div>
         <ActionList
          items={[
            {content: <a href={'/recurring_charges'} >recurring charges</a>},
            {content: 'Export file'},
          ]}
        />
      <Layout>
        <Layout.Section>
        <Card>
          <Card.Section>
            <PriceTestForm />
          </Card.Section>
        </Card>
          <Card title="Online store dashboard" class="product_list" sectioned>
            <Card.Section>
              <FormLayout>
                <FormLayout.Group>
                  <TextField 
                    value={this.state.term}
                    label="Keyword Search"
                    placeholder="Enter Term"
                    onChange={this.handleTermChange}
                  />
                  <Select
                    value= {this.state.collection}
                    label="Collection"
                    options={this.props.collections.map(CollectionTitles)}
                    placeholder="Select"
                    onChange={this.handleCollectionChange}
                  />
                </FormLayout.Group>
              </FormLayout>
            </Card.Section>
            <Card.Section>
             <ReactTable
                  data={this.state.products.map(CreateItem)}
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
          </Card.Section>
          </Card>
        </Layout.Section>
        <Layout.Section>
          <FooterHelp>
             The Lannister Group © 2017
          </FooterHelp>
        </Layout.Section>
      </Layout>
      </div>
    );  
  }
searchProducts() {
  $.ajax( {
    url: '/products/' + "?term=" + this.state.term + "&collection=" + this.state.collection_id,
    dataType: 'json',
    success: function(data) {
      this.setState({ products: data });
    }.bind(this),
    error: function(data) {
    }.bind(this)
   });
  }
}
  
document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('product-index-page')
  const data = JSON.parse(node.getAttribute('data'))
ReactDOM.render(<ProductIndex {...data}/>, node)
})

    
    