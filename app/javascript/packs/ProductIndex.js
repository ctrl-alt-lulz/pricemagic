import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import PriceTestForm from './PriceTestForm.js'
import PriceTestContainer from './PriceTestContainer.js'
import ProductIndexTable from './ProductIndexTable.js'
import { Page, Card, Select, Button, TextField, Stack, FormLayout, Layout, Checkbox, 
        FooterHelp, ActionList } from '@shopify/polaris';

class ProductIndex extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      term: '',
      collection_id: null,
      products: this.props.products,
      selected: {},
      selectAll: 0,
    };
    this.handleTermChange = this.handleTermChange.bind(this);
    this.handleCollectionChange = this.handleCollectionChange.bind(this);
    this.toggleRow = this.toggleRow.bind(this);
    this.toggleSelectAll = this.toggleSelectAll.bind(this);
    this.col_hash = this.props.collections.reduce(function ( total, current ) {
        total[ current.title ] = current.id;
        return total;
    }, {});
    this.product_hash = this.props.products.reduce(function ( total, current ) {
      total[ current.title ] = current.id;
      return total;
    }, {});
  }
  toggleRow(title) {
    console.log('toggle row')
		const newSelected = Object.assign({}, this.state.selected);
		newSelected[title] = !this.state.selected[title];
		this.setState({
			selected: newSelected,
			selectAll: 2
		});
		console.log(Object.keys(this.state.selected))
		console.log(this.state.selected)
	}
	toggleSelectAll() {
    console.log('toggle select all')
		let newSelected = {};
		if (this.state.selectAll === 0) {
			this.state.products.forEach(product => {
				newSelected[product.title] = true;
			});
		}
		this.setState({
			selected: newSelected,
			selectAll: this.state.selectAll === 0 ? 1 : 0
		});
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
    const selected = this.state.selected
    const selectAll = this.state.selectAll
    
    function CollectionTitles(collection) {
      return collection.title
    }
    return (
      <div>
      <Layout>
        <Layout.Section>

        <Card title="Online store dashboard" class="product_list" sectioned>
          <PriceTestForm />
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
            <ProductIndexTable 
              products={this.state.products} 
              selected={selected}
              selectAll={selectAll}
              onToggleRow={this.toggleRow}
              onToggleSelectAll={this.toggleSelectAll}
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

    
    